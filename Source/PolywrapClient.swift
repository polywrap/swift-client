import PolywrapClientNative

/// `PolywrapClient` provides methods to interact with the WRAP standard in Swift
public class PolywrapClient {
    public let ffi: FfiClient
    /// Creates a new `PolywrapClient`.
    ///
    /// - Parameters:
    ///   - client: An `FfiClient` object.
    public init(client: FfiClient) {
        self.ffi = client
    }

    /// Invokes a method without any arguments or environment variables.
    ///
    /// - Parameters:
    ///   - uri: A `Uri` object.
    ///   - method: The name of the method to invoke.
    /// - Throws: If the invocation fails.
    /// - Returns: A value of type `R`.
    public func invoke<R: Decodable>(
        uri: Uri,
        method: String
    ) throws -> R {
        let encodedArgs: [UInt8]? = nil
        let encodedEnv: [UInt8]? = nil
        let result = try self.ffi.invokeRaw(
            uri: uri.ffi,
            method: method,
            args: encodedArgs,
            env: encodedEnv,
            resolutionContext: nil
        )

        return try decode(value: result)
    }

    /// Invokes a method with arguments.
    ///
    /// - Parameters:
    ///   - uri: A `Uri` object.
    ///   - method: The name of the method to invoke.
    ///   - args: The arguments for the method.
    /// - Throws: If the invocation fails.
    /// - Returns: A value of type `R`.
    public func invoke<A: Encodable, R: Decodable>(
        uri: Uri,
        method: String,
        args: A?
    ) throws -> R {
        let encodedArgs = try encode(value: args)
        let encodedEnv: [UInt8]? = nil
        let result = try self.ffi.invokeRaw(
            uri: uri.ffi,
            method: method,
            args: encodedArgs,
            env: encodedEnv,
            resolutionContext: nil
        )

        return try decode(value: result)
    }

    /// Invokes a method with arguments.
    ///
    /// - Parameters:
    ///   - uri: A `Uri` object.
    ///   - method: The name of the method to invoke.
    ///   - env: The environment variables for the method.
    /// - Throws: If the invocation fails.
    /// - Returns: A value of type `R`.
    public func invoke<E: Encodable, R: Decodable>(
        uri: Uri,
        method: String,
        env: E?
    ) throws -> R {
        let encodedArgs: [UInt8]? = nil
        let encodedEnv = try encode(value: env)
        let result = try self.ffi.invokeRaw(
            uri: uri.ffi,
            method: method,
            args: encodedArgs,
            env: encodedEnv,
            resolutionContext: nil
        )

        return try decode(value: result)
    }

    /// Invokes a method with arguments and environment variables.
    ///
    /// - Parameters:
    ///   - uri: A `Uri` object.
    ///   - method: The name of the method to invoke.
    ///   - args: The arguments for the method.
    ///   - env: The environment variables for the method.
    /// - Throws: If the invocation fails.
    /// - Returns: A value of type `R`.
    public func invoke<A: Encodable, E: Encodable, R: Decodable>(
        uri: Uri,
        method: String,
        args: A?,
        env: E?
    ) throws -> R {
        let encodedArgs = try encode(value: args)
        let encodedEnv = try encode(value: env)
        let result = try self.ffi.invokeRaw(
            uri: uri.ffi,
            method: method,
            args: encodedArgs,
            env: encodedEnv,
            resolutionContext: nil
        )

        return try decode(value: result)
    }

    /// Retrieves environment variables by Uri.
    ///
    /// - Parameters:
    ///   - uri: A `Uri` object.
    /// - Throws: If the retrieval fails.
    /// - Returns: A value of type `T` or `nil` if no environment variables exist.
    public func getEnvByUri<T: Decodable>(_ uri: Uri) throws -> T? {
        guard let env = self.ffi.getEnvByUri(uri: uri.ffi) else {
            return nil
        }
        return try decode(value: env)
    }

    /// Retrieves implementations by Uri.
    ///
    /// - Parameters:
    ///   - uri: A `Uri` object.
    /// - Throws: If the retrieval fails.
    /// - Returns: An array of `Uri` objects.
    public func getImplementations(_ uri: Uri) throws -> [Uri] {
        let implementations = try self.ffi.getImplementations(uri: uri.ffi)
        return try implementations.compactMap { implementationUri -> Uri in
            return try Uri(ffi: implementationUri)
        }
    }

//    public func tryResolveUri(_ uri: Uri, _ resolutionContext: FfiUriResolutionContext?) throws -> <#Return Type#> {
//        return try self.ffi.loadWrapper(uri: uri.ffi, resolutionContext: resolutionContext)
//    }
}
