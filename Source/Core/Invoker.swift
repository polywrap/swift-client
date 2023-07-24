import Foundation
import PolywrapClientNative

/// `Invoker` is a class that wraps the FfiInvoker object and provides a method to perform invocations.
public class Invoker {
    /// FfiInvoker instance wrapped by this Invoker.
    let ffi: FfiInvoker

    /// Initializes an `Invoker` instance with the provided FfiInvoker.
    ///
    /// - Parameter ffi: The FfiInvoker instance to be wrapped by the Invoker.
    public init(_ ffi: FfiInvoker) {
        self.ffi = ffi
    }

    /// Performs an invocation using the provided Uri, method, arguments, environment, and resolution context.
    ///
    /// - Parameters:
    ///   - uri: The Uri of the entity to be invoked.
    ///   - method: The method to be invoked.
    ///   - args: The arguments in msgpack buffer to pass to the method. Optional.
    ///   - env: The environment in msgpack buffer to pass to the invocation. Optional.
    ///   - resolutionContext: The resolution context for the invocation. Optional.
    /// - Returns: A byte array of the result of the invocation.
    /// - Throws: If an error occurs during the invocation.
    public func invoke(
        uri: Uri,
        method: String,
        args: [UInt8]?,
        env: [UInt8]?,
        resolutionContext: FfiUriResolutionContext?
    ) throws -> [UInt8] {
        return try self.ffi.invokeRaw(
            uri: uri.ffi,
            method: method,
            args: args,
            env: env,
            resolutionContext: resolutionContext
        )
    }
}
