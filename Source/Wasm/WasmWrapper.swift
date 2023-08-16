//
//  WasmWrapper.swift
//  
//
//  Created by Cesar Brazon on 19/6/23.
//

import Foundation
import PolywrapClientNative

public enum WasmWrapperError: Error {
        case fromBytecodeError
}

/// A class representing a wrapper
public class WasmWrapper: IffiWrapper {

    /// A foreign function interface (FFI) to a Wasm wrapper provided by PolywrapClientNativeLib.
    internal let ffi: FfiWrapper

    /// Initializes a new WasmWrapper instance.
    ///
    /// - Parameter module: A Wasm module represented as an array of bytes.
    public init(module: [UInt8]) throws {
        do {
            self.ffi = try ffiWrapperFromBytecode(bytes: module)
        } catch {
            throw WasmWrapperError.fromBytecodeError
        }
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
