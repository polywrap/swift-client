//
//  PluginWrapper.swift
//  
//
//  Created by Cesar Brazon on 21/6/23.
//

import Foundation

public class PluginWrapper: FfiWrapper {

    let instance: PluginModule
    
    public init(_ instance: PluginModule) {
        self.instance = instance
    }
    
    public func invoke(
        method: String,
        args: [UInt8]?,
        env: [UInt8]?,
        invoker: FfiInvoker
    ) throws -> [UInt8] {
        try self.instance._wrap_invoke(
            method: method,
            args: args,
            env: env,
            invoker: Invoker(invoker)
        )
    }
    
    public func invoke(
        method: String,
        args: [UInt8]?,
        env: [UInt8]?,
        invoker: Invoker
    ) throws -> [UInt8] {
        try self.instance._wrap_invoke(
            method: method,
            args: args,
            env: env,
            invoker: invoker
        )
    }
}
