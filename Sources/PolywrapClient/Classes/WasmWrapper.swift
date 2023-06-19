//
//  WasmWrapper.swift
//  
//
//  Created by Cesar Brazon on 19/6/23.
//

import Foundation

public class WasmWrapper {
    public let ffi: FfiWasmWrapper
    
    public init(module: [UInt8]!) {
        self.ffi = FfiWasmWrapper(wasmModule: module)
    }
}
