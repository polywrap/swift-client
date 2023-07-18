//
//  BuilderConfig.swift
//  
//
//  Created by Cesar Brazon on 12/6/23.
//

import Foundation
import PolywrapClientNativeLib

/// `BuilderConfig` class provides a configuration interface for the `PolywrapClient`.
public class BuilderConfig {
    public let ffi: FfiBuilderConfig

    /// Creates an instance of `BuilderConfig`.
    public init() {
        self.ffi = FfiBuilderConfig()
    }

    /// Adds an environment variable to the configuration.
    ///
    /// - Parameters:
    ///   - uri: The `Uri` key for the environment variable.
    ///   - env: The environment variable to add. Must conform to the Encodable protocol.
    /// - Throws: If encoding fails.
    /// - Returns: The same instance of `BuilderConfig` for method chaining.
    public func addEnv<T: Encodable>(_ uri: Uri, _ env: T) throws -> Self {
        let encodedEnv = try encode(value: env)
        self.ffi.addEnv(uri: uri.ffi, env: encodedEnv)
        return self
    }

    /// Removes an environment variable from the configuration.
    ///
    /// - Parameter uri: The `Uri` key for the environment variable to remove.
    /// - Returns: The same instance of `BuilderConfig` for method chaining.
    public func removeEnv(_ uri: Uri) -> Self {
        self.ffi.removeEnv(uri: uri.ffi)
        return self
    }

    /// Adds a wrapper to the configuration.
    ///
    /// - Parameters:
    ///   - uri: The `Uri` of the wrapper.
    ///   - wrapper: The wrapper to add.
    /// - Returns: The same instance of `BuilderConfig` for method chaining.
    public func addWrapper(_ uri: Uri, _ wrapper: FfiWrapper) -> Self {
        self.ffi.addWrapper(uri: uri.ffi, wrapper: wrapper)
        return self
    }

    /// Removes a wrapper from the configuration.
    ///
    /// - Parameter uri: The `Uri` of the wrapper to remove.
    /// - Returns: The same instance of `BuilderConfig` for method chaining.
    public func removeWrapper(_ uri: Uri) -> Self {
        self.ffi.removeWrapper(uri: uri.ffi)
        return self
    }

    /// Adds a package to the configuration.
    ///
    /// - Parameters:
    ///   - uri: The `Uri` of the package.
    ///   - package: The package to add.
    /// - Returns: The same instance of `BuilderConfig` for method chaining.
    public func addPackage(_ uri: Uri, _ package: FfiWrapPackage) -> Self {
        self.ffi.addPackage(uri: uri.ffi, package: package)
        return self
    }

    /// Removes a package from the configuration.
    ///
    /// - Parameter uri: The `Uri` of the package to remove.
    /// - Returns: The same instance of `BuilderConfig` for method chaining.
    public func removePackage(_ uri: Uri) -> Self {
        self.ffi.removePackage(uri: uri.ffi)
        return self
    }

    /// Adds a redirect to the configuration.
    ///
    /// - Parameters:
    ///   - from: The `Uri` redirect from.
    ///   - to: The `Uri` redirect to.
    /// - Returns: The same instance of `BuilderConfig` for method chaining.
    public func addRedirect(_ from: Uri, _ to: Uri) -> Self {
        self.ffi.addRedirect(from: from.ffi, to: to.ffi)
        return self
    }

    /// Removes a redirect from the configuration.
    ///
    /// - Parameters from: The `Uri` of the redirect to remove.
    /// - Returns: The same instance of `BuilderConfig` for method chaining.
    public func removeRedirect(_ from: Uri) -> Self {
        self.ffi.removeRedirect(from: from.ffi)
        return self
    }

    /// Adds an interface implementation to the configuration.
    ///
    /// - Parameters:
    ///   - uri: The `Uri` of the interface.
    ///   - implementationUri: The `Uri` of the implementation.
    /// - Returns: The same instance of `BuilderConfig` for method chaining.
    public func addInterfaceImplementation(_ uri: Uri, _ implementationUri: Uri) -> Self {
        self.ffi.addInterfaceImplementation(interfaceUri: uri.ffi, implementationUri: implementationUri.ffi)
        return self
    }

    /// Adds multiple interface implementations to the configuration.
    ///
    /// - Parameters:
    ///   - uri: The `Uri` of the interface.
    ///   - implementationUris: An array of `Uri`s for the implementations.
    /// - Returns: The same instance of `BuilderConfig` for method chaining.
    public func addInterfaceImplementations(_ uri: Uri, _ implementationUris: [Uri]) -> Self {
        let uriArray = implementationUris.compactMap { implementationUri -> FfiUri? in
            return implementationUri.ffi
        }
        self.ffi.addInterfaceImplementations(interfaceUri: uri.ffi, implementationUris: uriArray)
        return self
    }

    /// Removes an interface implementation from the configuration.
    ///
    /// - Parameters:
    ///   - uri: The `Uri` of the interface.
    ///   - implementationUri: The `Uri` of the implementation to remove.
    /// - Returns: The same instance of `BuilderConfig` for method chaining.
    public func removeInterfaceImplementation(_ uri: Uri, _ implementationUri: Uri) -> Self {
        self.ffi.removeInterfaceImplementation(interfaceUri: uri.ffi, implementationUri: implementationUri.ffi)
        return self
    }

    /*
    /// Adds a resolver to the configuration.
    ///
    /// - Parameter resolver: The resolver to add.
    /// - Returns: The same instance of `BuilderConfig` for method chaining.
    public func addResolver(_ resolver: FfiUriResolver) -> Self {
        self.ffi.addResolver(resolver: resolver)
        return self
    }
    */

    /// Adds system defaults to the configuration.
    ///
    /// - Returns: The same instance of `BuilderConfig` for method chaining.
    public func addSystemDefault() -> Self {
        self.ffi.addSystemDefaults()
        return self
    }

    /// Adds Web3 defaults to the configuration.
    ///
    /// - Returns: The same instance of `BuilderConfig` for method chaining.
    public func addWeb3Default() -> Self {
        self.ffi.addWeb3Defaults()
        return self
    }

    /// Builds a `PolywrapClient` from the current configuration.
    ///
    /// - Returns: An instance of `PolywrapClient`.
    public func build() -> PolywrapClient {
        let ffiClient = self.ffi.build()
        return PolywrapClient(client: ffiClient)
    }
}
