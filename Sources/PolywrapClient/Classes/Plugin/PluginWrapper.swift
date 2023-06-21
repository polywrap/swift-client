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
        invoker: FfiInvoker,
        abortHandler _: FfiAbortHandlerWrapping?
    ) throws -> [UInt8] {
        self.instance._wrap_invoke(
            method: method,
            args: args!,
            env: env,
            invoker: invoker
        )
    }
}
