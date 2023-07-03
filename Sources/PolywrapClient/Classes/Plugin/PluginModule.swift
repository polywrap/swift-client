//
//  PluginModule.swift
//  
//
//  Created by Cesar Brazon on 19/6/23.
//

import Foundation
import MessagePacker

public typealias PluginMethod = (
    _ args: [UInt8],
    _ env: [UInt8]?,
    _ invoker: FfiInvoker
) throws -> Encodable

enum PluginError: Error {
    case methodNotFound
}

open class PluginModule {
    public var methodsMap: [
        String: PluginMethod
    ] = [:]

    public init() {}
    
    public func addMethod<T: Codable, E: Codable, R: Codable>(
        name: String,
        closure: @escaping (
            _ args: T,
            _ env: E?,
            _ invoker: FfiInvoker
        ) throws -> R
    ) {
        methodsMap[name] = {(
            _ args: [UInt8],
            _ env: [UInt8]?,
            _ invoker: FfiInvoker
        ) throws -> Encodable in
            let decoder = MessagePackDecoder()
            let decoded_args = try decoder.decode(T.self, from: Data(args))
//            if let
//            let decoded_env = try decoder.decode(E.self, from: Data(env))
            return try (closure)(decoded_args, nil, invoker)
        
        }
    }

    public func _wrap_invoke(
        method: String,
        args: [UInt8],
        env: [UInt8]?,
        invoker: FfiInvoker
    ) throws -> [UInt8] {
        guard let fn = self.methodsMap[method] else {
            throw PluginError.methodNotFound
        }

        let result = try fn(args, env, invoker)

        return try encode(value: result)
    }
}
