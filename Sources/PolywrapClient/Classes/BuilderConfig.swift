//
//  BuilderConfig.swift
//  
//
//  Created by Cesar Brazon on 12/6/23.
//

import Foundation

public class BuilderConfig {
    public let ffi: FfiBuilderConfig
    
    public init() {
        self.ffi = FfiBuilderConfig()
    }

    public func addEnv<T: Encodable>(_ uri: Uri, _ env: T) throws -> Self {
        let encoded_env = try encode(value: env)
        self.ffi.addEnv(uri: uri.ffi, env: encoded_env)
        return self
    }
    
    public func removeEnv(_ uri: Uri) -> Self {
        self.ffi.removeEnv(uri: uri.ffi)
        return self
    }
    
    public func addWrapper(_ uri: Uri, _ wrapper: FfiWrapper) -> Self {
        self.ffi.addWrapper(uri: uri.ffi, wrapper: wrapper)
        return self
    }
    
    public func removeWrapper(_ uri: Uri) -> Self {
        self.ffi.removeWrapper(uri: uri.ffi)
        return self
    }
    
    public func addPackage(_ uri: Uri, _ package: FfiWrapPackage) -> Self {
        self.ffi.addPackage(uri: uri.ffi, package: package)
        return self
    }
    
    public func removePackage(_ uri: Uri) -> Self {
        self.ffi.removePackage(uri: uri.ffi)
        return self
    }
    
    public func addRedirect(_ from: Uri, _ to: Uri) -> Self {
        self.ffi.addRedirect(from: from.ffi, to: to.ffi)
        return self
    }

    public func removeRedirect(_ from: Uri, _ to: Uri) -> Self {
        self.ffi.removeRedirect(from: from.ffi)
        return self
    }
    
    public func addInterfaceImplementation(_ uri: Uri, _ implementationUri: Uri) -> Self {
        self.ffi.addInterfaceImplementation(interfaceUri: uri.ffi, implementationUri: implementationUri.ffi)
        return self
    }
    
    public func addInterfaceImplementations(_ uri: Uri, _ implementationUris: [Uri]) -> Self {
        let uriArray = implementationUris.compactMap { implementationUri -> FfiUri? in
            return implementationUri.ffi
        }
        self.ffi.addInterfaceImplementations(interfaceUri: uri.ffi, implementationUris: uriArray)
        return self
    }
    
    public func removeInterfaceImplementation(_ uri: Uri, _ implementationUri: Uri) -> Self {
        self.ffi.removeInterfaceImplementation(interfaceUri: uri.ffi, implementationUri: implementationUri.ffi)
        return self
    }

    // public func addResolver(_ resolver: FfiUriResolver) -> Self {
    //     self.ffi.addResolver(resolver: resolver)
    //     return self
    // }
    
    public func build() -> PolywrapClient {
        let ffiClient = self.ffi.build()
        return PolywrapClient(client: ffiClient)
    }
}
