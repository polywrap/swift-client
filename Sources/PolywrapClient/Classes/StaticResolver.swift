//
//  StaticResolver.swift
//  
//
//  Created by Cesar Brazon on 16/6/23.
//

import Foundation

public class StaticResolver {
    let resolver: FfiStaticUriResolver;
    
    public init(_ uriMap: [String: FfiUriPackageOrWrapper]) {
        resolver = FfiStaticUriResolver(uriMap: uriMap)
    }
}
