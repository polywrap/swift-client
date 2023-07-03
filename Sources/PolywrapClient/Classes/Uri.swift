//
//  Uri.swift
//  
//
//  Created by Cesar Brazon on 12/6/23.
//

import Foundation

public class Uri {
    public let ffi: FfiUri;

    public init(_ uri: String) throws {
        self.ffi = try ffiUriFromString(uri: uri)
    }
    
    public init(ffi: FfiUri) throws {
        self.ffi = ffi
    }
    
    public init(_ authority: String, _ path: String, uri: String) {
        self.ffi = FfiUri(authority: authority, path: path, uri: uri)
    }
}
