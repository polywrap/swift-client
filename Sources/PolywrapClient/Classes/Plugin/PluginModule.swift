//
//  PluginModule.swift
//  
//
//  Created by Cesar Brazon on 19/6/23.
//

import Foundation

open class PluginModule {
    public init() {}
//    public var methodsMap: [String: (_ args: Codable?) async -> Codable] = [:]
//
//    public func addMethod<U: Codable>(name: String, closure: @escaping (Codable?) async -> U) {
//        methodsMap[name] = { (args: Codable?) async -> Codable in
//            return await (closure)(args)
//        }
//    }

    public func _wrap_invoke(
        method: String,
        args: Codable?,
        env: Codable?,
        invoker: FfiInvoker
    ) -> [UInt8] {
        
//        guard let fn = self.methodsMap[method] else {
//            fatalError("Method '\(method)' not found in methodsMap.")
//        }
        [0]
        
    }
}
