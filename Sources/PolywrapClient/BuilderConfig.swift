//
//  BuilderConfig.swift
//  
//
//  Created by Cesar Brazon on 12/6/23.
//

import Foundation

public class BuilderConfig {
    public let builder: FfiBuilderConfig
    public init() {
        self.builder = FfiBuilderConfig()
    }
    
    public func addEnv<T: Codable>(_ uri: Uri, env: T) throws {
        let env_as_msgpack = try! encode(value: env)
        self.builder.addEnv(uri: uri.ffiUri, env: env_as_msgpack)
    }
    
    public func removeEnv(_ uri: Uri) {
        self.builder.removeEnv(uri: uri.ffiUri)
    }
}
