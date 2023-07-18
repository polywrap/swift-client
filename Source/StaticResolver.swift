//
//  StaticResolver.swift
//  
//
//  Created by Cesar Brazon on 16/6/23.
//

import Foundation
import PolywrapClientNativeLib

public class StaticResolver {
    let resolver: FfiStaticUriResolver?

    public init(_ uriMap: [String: FfiUriPackageOrWrapper]) throws {
//        resolver = try? FfiStaticUriResolver(uriMap: uriMap)
        self.resolver = nil
    }
}
