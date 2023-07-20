//
//  PluginModule.swift
//
//
//  Created by Cesar Brazon on 19/6/23.
//

import Foundation
import MessagePacker
import PolywrapClientNativeLib

/// Codable structure with no content.
public struct VoidCodable: Codable {}

/// Type alias for a plugin method. A plugin method is a function that takes a msgpack buffer of arguments, an optional msgpack 
/// buffer for the environment, and an Invoker, and it returns an optional value conforming to Encodable.
public typealias PluginMethod = (
    _ args: [UInt8],
    _ env: [UInt8]?,
    _ invoker: Invoker
) throws -> Encodable?

/// Type alias for an asynchronous plugin method. Similar to PluginMethod but this one is asynchronous.
public typealias PluginAsyncMethod = (
    _ args: [UInt8],
    _ env: [UInt8]?,
    _ invoker: Invoker
) async throws -> Encodable?

/// An enumeration to represent whether a plugin method is asynchronous or synchronous.
public enum MethodType {
    case async(PluginAsyncMethod)
    case sync(PluginMethod)
}

/// Custom error type for plugin related errors.
enum PluginError: Error {
    case methodNotFound
}

/// `PluginModule` is a class that provides a way to add and invoke synchronous and asynchronous plugin methods.
open class PluginModule {
    /// Dictionary to map method names to their respective `MethodType` (sync or async).
    public var methodsMap: [String: MethodType] = [:]

    public init() {}

    private func decode<T: Codable>(_ bytes: [UInt8]?) throws -> T? {
        guard let bytes = bytes else {
            return nil
        }
        let decoder = MessagePackDecoder()
        return try decoder.decode(T.self, from: Data(bytes))
    }

    public func addMethod<T: Codable, E: Codable, R: Codable>(
        name: String,
        closure: @escaping (_ args: T, _ env: E?, _ invoker: Invoker) throws -> R
    ) {
        methodsMap[name] = MethodType.sync({(_ args: [UInt8], _ env: [UInt8]?, _ invoker: Invoker) throws -> Encodable? in
            let decodedArgs: T? = try self.decode(args)
            let decodedEnv: E? = try self.decode(env)
            guard let sanitizedArgs = decodedArgs else {
                return [] as [UInt8]
            }

            return try closure(sanitizedArgs, decodedEnv, invoker)
        })
    }

    public func addVoidMethod<T: Codable, E: Codable>(
        name: String,
        closure: @escaping (_ args: T, _ env: E?, _ invoker: Invoker) throws -> Void
    ) {
        methodsMap[name] = MethodType.sync({ args, env, invoker in
            let decodedArgs: T? = try self.decode(args)
            let decodedEnv: E? = try self.decode(env)

            guard let sanitizedArgs = decodedArgs else {
                return [] as [UInt8]
            }
            try closure(sanitizedArgs, decodedEnv, invoker)
            return AnyEncodable(VoidCodable())
        })
    }

    public func addAsyncMethod<T: Codable, E: Codable, R: Codable>(
        name: String,
        closure: @escaping (_ args: T, _ env: E?, _ invoker: Invoker) async throws -> R
    ) {
        methodsMap[name] = MethodType.async({(_ args: [UInt8], _ env: [UInt8]?, _ invoker: Invoker) async throws -> Encodable? in
            let decodedArgs: T? = try self.decode(args)
            let decodedEnv: E? = try self.decode(env)
            guard let sanitizedArgs = decodedArgs else {
                return [] as [UInt8]
            }

            return try await closure(sanitizedArgs, decodedEnv, invoker)
        })
    }

    /// This function tries to call a plugin method by its name. 
    /// It takes the method's name, its arguments, the environment, and the Invoker as parameters.
    /// The function first checks if the method with the given name exists in the `methodsMap`.
    /// If it doesn't exist, it throws a `PluginError.methodNotFound` error.
    /// If the method is found, it invokes the method using the provided arguments, environment, and invoker.
    /// If the method returns a result, it encodes the result into a byte array.
    /// If the method does not return a result, it returns an empty array.
    ///
    /// - Parameters:
    ///   - method: The name of the method to invoke.
    ///   - args: The arguments to pass to the method as a byte array.
    ///   - env: The environment to pass to the method as a byte array.
    ///   - invoker: The Invoker to pass to the method.
    ///
    /// - Throws: `PluginError.methodNotFound` if the method is not found in the `methodsMap`.
    //// It also propagates any errors that may occur during the execution of the method.
    ///
    /// - Returns: The result of the method invocation encoded into a byte array.
    public func wrapInvoke(
        method: String,
        args: [UInt8]?,
        env: [UInt8]?,
        invoker: Invoker
    ) throws -> [UInt8] {
        guard let method = self.methodsMap[method] else {
            throw PluginError.methodNotFound
        }

        let sanitizedArgs = args ?? [] as [UInt8]
        let result: Encodable?

        switch method {
        case .sync(let syncMethod):
            result = try syncMethod(sanitizedArgs, env, invoker)
        case .async(let asyncMethod):
            result = try runBlocking {
                return try await asyncMethod(sanitizedArgs, env, invoker)
            }
        }

        if let result = result {
            return try encode(value: AnyEncodable(result))
        } else {
            return []
        }
    }
}
