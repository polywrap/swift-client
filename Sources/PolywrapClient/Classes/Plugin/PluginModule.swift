//
//  PluginModule.swift
//
//
//  Created by Cesar Brazon on 19/6/23.
//

import Foundation
import MessagePacker

public struct VoidCodable: Codable {}

public typealias PluginMethod = (
    _ args: [UInt8],
    _ env: [UInt8]?,
    _ invoker: Invoker
) throws -> Encodable?

public typealias PluginAsyncMethod = (
    _ args: [UInt8],
    _ env: [UInt8]?,
    _ invoker: Invoker
) async throws -> Encodable?

public enum MethodType {
    case async(PluginAsyncMethod)
    case sync(PluginMethod)
}

enum PluginError: Error {
    case methodNotFound
}

open class PluginModule {
    public var methodsMap: [String: MethodType] = [:]
    public var asyncMethodsMap: [String: MethodType] = [:]

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
    
    public func _wrap_invoke(
        method: String,
        args: [UInt8]?,
        env: [UInt8]?,
        invoker: Invoker
    ) throws -> [UInt8] {
        guard let fn = self.methodsMap[method] else {
            throw PluginError.methodNotFound
        }

        let sanitizedArgs = args ?? [] as [UInt8]
        let result: Encodable?
        
        switch fn {
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
