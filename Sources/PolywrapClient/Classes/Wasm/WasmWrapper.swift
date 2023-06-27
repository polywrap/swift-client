//
//  WasmWrapper.swift
//  
//
//  Created by Cesar Brazon on 19/6/23.
//

import Foundation

public class WasmWrapper: FfiWrapper {
    public let ffi: FfiWasmWrapper

    public init(module: [UInt8]!) {
        self.ffi = FfiWasmWrapper(wasmModule: module)
    }

    public func invoke(
        method: String,
        args: [UInt8]?,
        env: [UInt8]?,
        invoker: FfiInvoker
    ) throws -> [UInt8] {
        try self.ffi.invoke(
            method: method,
            args: args,
            env: env,
            invoker: invoker
        )
    }
}
