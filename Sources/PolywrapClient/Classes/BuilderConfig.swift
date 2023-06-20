//
//  BuilderConfig.swift
//  
//
//  Created by Cesar Brazon on 12/6/23.
//

import Foundation

public class BuilderConfig: FfiBuilderConfig {
    public func addEnv<T: Codable>(_ uri: Uri, env: T) throws {
        let env_as_msgpack = try! encode(value: env)
        self.addEnv(uri: uri.ffi, env: env_as_msgpack)
    }
    
    public func removeEnv(_ uri: Uri) {
        self.removeEnv(uri: uri.ffi)
    }
    
    public func addWrapper(_ uri: Uri, _ wrapper: WasmWrapper) {
        self.addWrapper(uri: uri.ffi, wrapper: wrapper)
    }
    
    public override func build() -> PolywrapClient {
        self.build()
    }
}
