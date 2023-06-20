//
//  WrapPackage.swift
//  
//
//  Created by Cesar Brazon on 19/6/23.
//

import Foundation
public class WasmPackage {
    public let ffi: FfiWasmWrapper

    public init(_ module: [UInt8]) {
        self.ffi = FfiWasmWrapper(wasmModule: module)
    }

//    public func createWrapper() throws -> FfiWrapper {
//        return WasmWrapper(wasmModule: )
//    }
}
