//
//  Uri.swift
//  
//
//  Created by Cesar Brazon on 12/6/23.
//

import Foundation

public class Uri {
    public var ffi: FfiUri;

    public init?(_ uri: String) {
        self.ffi = FfiUri.fromString(uri: uri)
    }
    
    public init?(_ authority: String, _ path: String, uri: String) {
        self.ffi = FfiUri(authority: authority, path: path, uri: uri)
    }
}
