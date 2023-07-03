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
    
    public func addInterfaceImplementations(_ uri: Uri, _ implementationUris: [String]) throws -> Self {
        let uriArray = try implementationUris.compactMap { implementationUri -> FfiUri? in
            guard let uri = try? Uri(implementationUri) else {
                throw FfiError.UriParseError(err: "Error parsing implementation uri \(implementationUri)")
            }
            return uri.ffi
        }
        self.ffi.addInterfaceImplementations(interfaceUri: uri.ffi, implementationUri: uriArray)
        return self
    }

    
    public func build() -> PolywrapClient {
        let ffiClient = self.ffi.build()
        return PolywrapClient(client: ffiClient)
    }
}
