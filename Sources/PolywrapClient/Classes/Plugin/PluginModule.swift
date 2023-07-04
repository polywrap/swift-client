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
    _ args: [UInt8]?,
    _ env: [UInt8]?,
    _ invoker: Invoker
) throws -> Encodable?

enum PluginError: Error {
    case methodNotFound
}

open class PluginModule {
    public var methodsMap: [String: PluginMethod] = [:]

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
        closure: @escaping (_ args: T?, _ env: E?, _ invoker: Invoker) throws -> R
    ) {
        methodsMap[name] = { [weak self] args, env, invoker in
            let decodedArgs: T? = try self?.decode(args)
            let decodedEnv: E? = try self?.decode(env)
            return try closure(decodedArgs, decodedEnv, invoker)
        }
    }

    public func addVoidMethod<T: Codable, E: Codable>(
        name: String,
        closure: @escaping (_ args: T?, _ env: E?, _ invoker: Invoker) throws -> Void
    ) {
        methodsMap[name] = { [weak self] args, env, invoker in
            let decodedArgs: T? = try self?.decode(args)
            let decodedEnv: E? = try self?.decode(env)
            try closure(decodedArgs, decodedEnv, invoker)
            return AnyEncodable(VoidCodable())
        }
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

        let result = try fn(args, env, invoker)
        if let result = result {
            return try encode(value: AnyEncodable(result))
        } else {
            return []
        }
    }
}
