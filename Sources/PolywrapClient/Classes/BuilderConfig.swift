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

    public func addEnv<T: Encodable>(_ uri: Uri, _ env: T) throws {
        let encoded_env = try encode(value: env)
        self.ffi.addEnv(uri: uri.ffi, env: encoded_env)
    }
    
    public func removeEnv(_ uri: Uri) {
        self.ffi.removeEnv(uri: uri.ffi)
    }
    
    public func addWrapper(_ uri: Uri, _ wrapper: FfiWrapper) {
        self.ffi.addWrapper(uri: uri.ffi, wrapper: wrapper)
    }
    
    public func removeWrapper(_ uri: Uri) {
        self.ffi.removeWrapper(uri: uri.ffi)
    }
    
    public func addPackage(_ uri: Uri, _ package: FfiWrapPackage) {
        self.ffi.addPackage(uri: uri.ffi, package: package)
    }
    
    public func removePackage(_ uri: Uri) {
        self.ffi.removePackage(uri: uri.ffi)
    }
    
    public func addInterfaceImplementations(_ uri: Uri, _ implementationUris: [String]) {
//        self.ffi.addInterfaceImplementation(interfaceUri: <#T##FfiUri#>, implementationUri: <#T##FfiUri#>)
    }
    
    public func build() -> PolywrapClient {
        let ffiClient = self.ffi.build()
        return PolywrapClient(client: ffiClient)
    }
}
