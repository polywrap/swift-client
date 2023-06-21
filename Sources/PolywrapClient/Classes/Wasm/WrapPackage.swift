//
//  WrapPackage.swift
//  
//
//  Created by Cesar Brazon on 19/6/23.
//

import Foundation
public class WasmPackage: FfiWrapPackage {
    // TODO: Add file reader and get module from path given
    public let module: [UInt8]?
    
    public init(_ module: [UInt8]?) {
        self.module = module
    }

    public func createWrapper() throws -> FfiWrapper {
        return WasmWrapper(module: self.module)
    }
}
