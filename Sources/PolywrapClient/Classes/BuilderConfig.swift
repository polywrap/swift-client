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

    public func addEnv<T: Codable>(_ uri: Uri, env: T) throws {
        let env_as_msgpack = try! encode(value: env)
        self.ffi.addEnv(uri: uri.ffi, env: env_as_msgpack)
    }
    
    public func removeEnv(_ uri: Uri) {
        self.ffi.removeEnv(uri: uri.ffi)
    }
    
    public func addWrapper(_ uri: Uri, _ wrapper: FfiWrapper) {
        self.ffi.addWrapper(uri: uri.ffi, wrapper: wrapper)
    }
    
    public func addPackage(_ uri: Uri, _ package: FfiWrapPackage) {
        self.ffi.addPackage(uri: uri.ffi, package: package)
    }
    
    public func build() -> PolywrapClient {
        let ffiClient = self.ffi.build()
        return PolywrapClient(client: ffiClient)
    }
}
