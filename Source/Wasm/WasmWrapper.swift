//
//  WasmWrapper.swift
//  
//
//  Created by Cesar Brazon on 19/6/23.
//

import Foundation
import PolywrapClientNative

/// A class representing a wrapper
public class WasmWrapper: FfiWrapper {

    /// A foreign function interface (FFI) to a Wasm wrapper provided by PolywrapClientNativeLib.
    public let ffi: FfiWasmWrapper

    /// Initializes a new WasmWrapper instance.
    ///
    /// - Parameter module: A Wasm module represented as an array of bytes.
    public init(module: [UInt8]) {
        self.ffi = FfiWasmWrapper(wasmModule: module)
    }

    /// Invokes a method on the Wasm module.
    ///
    /// - Parameters:
    ///   - method: The name of the method to invoke.
    ///   - args: The arguments for the method, represented as a msgpack buffer 
    ///   - env: The environment for the method, represented as a msgpack buffer
    ///   - invoker: An `FfiInvoker` instance to use for invoking the method.
    /// - Returns: The result of the invocation, represented as a msgpack buffer
    /// - Throws: An error if the invocation fails.
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
