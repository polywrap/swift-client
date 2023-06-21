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
) -> Encodable


open class PluginModule {
    public var methodsMap: [
        String: PluginMethod
    ] = [:]

    public init() {}
    
    public func addMethod<T: Codable, U: Codable>(
        name: String,
        closure: @escaping (
            _ args: T,
            _ env: Codable?,
            _ invoker: FfiInvoker
        ) -> U
    ) {
        methodsMap[name] = {(
            _ args: [UInt8],
            _ env: [UInt8]?,
            _ invoker: FfiInvoker
        ) -> Encodable in
            let decoded_args = try! MessagePackDecoder().decode(T.self, from: Data(args))

            return (closure)(decoded_args, nil, invoker)
        
        }
    }

    public func _wrap_invoke(
        method: String,
        args: [UInt8],
        env: [UInt8]?,
        invoker: FfiInvoker
    ) -> [UInt8] {
        guard let fn = self.methodsMap[method] else {
            fatalError("Method '\(method)' not found in methodsMap.")
        }

        let result = fn(args, env, invoker)

        let encoded_result = try! encode(value: result)
        return encoded_result
    }
}
