//
//  PluginWrapper.swift
//  
//
//  Created by Cesar Brazon on 21/6/23.
//

import Foundation
import PolywrapClientNative

/// Represents a wrapper for a plugin module. 
/// Provides functionality to invoke methods on the wrapped plugin module through the Polywrap Client
public class PluginWrapper: IffiWrapper {

    /// The instance of the `PluginModule` to be wrapped.
    let instance: PluginModule

    /// Creates a new instance of `PluginWrapper`.
    ///
    /// - Parameter instance: The `PluginModule` instance to wrap.
    public init(_ instance: PluginModule) {
        self.instance = instance
    }

    /// Invokes a method on the wrapped `PluginModule` using a given `FfiInvoker`.
    ///
    /// - Parameters:
    ///   - method: The method to be invoked on the plugin module.
    ///   - args: The arguments for the method as an msgpack buffer (`UInt8`). This can be `nil`.
    ///   - env: The environment for the method as an msgpack buffer (`UInt8`). This can be `nil`.
    ///   - invoker: An `FfiInvoker` to invoke the method.
    /// - Returns: The result of the invocation as an msgpack buffer (`UInt8`).
    /// - Throws: Rethrows errors from the wrapped `PluginModule`.
    public func invoke(
        method: String,
        args: [UInt8]?,
        env: [UInt8]?,
        invoker: FfiInvoker
    ) throws -> [UInt8] {
        try self.instance.wrapInvoke(
            method: method,
            args: args,
            env: env,
            invoker: Invoker(invoker)
        )
    }

    /// Invokes a method on the wrapped `PluginModule` using a given `Invoker`.
    ///
    /// - Parameters:
    ///   - method: The method to be invoked on the plugin module.
    ///   - args: The arguments for the method as a msgpack buffer. This can be `nil`.
    ///   - env: The environment for the method as a msgpack buffer. This can be `nil`.
    ///   - invoker: An `Invoker` to invoke the method.
    /// - Returns: The result of the invocation as a msgpack buffer.
    /// - Throws: Rethrows errors from the wrapped `PluginModule`.
    public func invoke(
        method: String,
        args: [UInt8]?,
        env: [UInt8]?,
        invoker: Invoker
    ) throws -> [UInt8] {
        try self.instance.wrapInvoke(
            method: method,
            args: args,
            env: env,
            invoker: invoker
        )
    }
}
