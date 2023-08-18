//
//  PluginModule.swift
//
//
//  Created by Cesar Brazon on 19/6/23.
//

import Foundation
import MessagePacker
import PolywrapClientNative

/// Codable structure with no content.
public struct VoidCodable: Codable {}

/// Type alias for a plugin method. A plugin method is a function that takes a msgpack buffer of arguments, an optional msgpack 
/// buffer for the environment, and an Invoker, and it returns an optional value conforming to Encodable.
public typealias PluginMethod = (
    _ args: [UInt8],
    _ env: [UInt8]?,
    _ invoker: Invoker
) throws -> Encodable?

/// Custom error type for plugin related errors.
enum PluginError: Error {
    case methodNotFound
}

public protocol PluginModule {
    var methodsMap: [String: PluginMethod] { get set }
}

extension PluginModule {
    public mutating func addMethod<T: Codable, E: Codable, R: Codable>(
        name: String,
        closure: @escaping (_ args: T, _ env: E?, _ invoker: Invoker) throws -> R
    ) {
        methodsMap[name] = {(_ args: [UInt8], _ env: [UInt8]?, _ invoker: Invoker) throws -> Encodable? in
            let decodedArgs: T = try decode(value: args)
            let decodedEnv: E? = try env.flatMap { try decode(value: $0) }
            return try closure(decodedArgs, decodedEnv, invoker)
        }
    }

    public mutating func addVoidMethod<T: Codable, E: Codable>(
        name: String,
        closure: @escaping (_ args: T, _ env: E?, _ invoker: Invoker) throws -> Void
    ) {
        methodsMap[name] = { args, env, invoker in
            let decodedArgs: T = try decode(value: args)
            let decodedEnv: E? = try env.flatMap { try decode(value: $0) }
            try closure(decodedArgs, decodedEnv, invoker)
            return AnyEncodable(VoidCodable())
        }
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
        let result: Encodable? = try method(sanitizedArgs, env, invoker)

        if let result = result {
            return try encode(value: AnyEncodable(result))
        } else {
            return []
        }
    }
}
