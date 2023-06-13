//
//  Uri.swift
//  
//
//  Created by Cesar Brazon on 12/6/23.
//

import Foundation

public class Uri {
    public var ffiUri: FfiUri;

    public init?(_ uri: String) {
        self.ffiUri = FfiUri.fromString(uri: uri)
    }
    
    public init?(_ authority: String, _ path: String, uri: String) {
        self.ffiUri = FfiUri(authority: authority, path: path, uri: uri)
    }
}
