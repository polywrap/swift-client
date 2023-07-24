//
//  Invoker.swift
//  
//
//  Created by Cesar Brazon on 18/7/23.
//

import Foundation
import PolywrapClient

public class MockInvoker: FFIInvokerProtocol {
    public func invokeRaw(uri: FfiUri, method: String, args: [UInt8]?, env: [UInt8]?, resolutionContext: FfiUriResolutionContext?) throws -> [UInt8] {
        if method == "foo" {
            return [195]
        } else {
            return [194]
        }
    }
    
    public func getImplementations(uri: FfiUri) throws -> [FfiUri] {
        return []
    }
    
    public func getInterfaces() -> [String : [FfiUri]]? {
        return [:]
    }
    
    public func getEnvByUri(uri: FfiUri) -> [UInt8]? {
        return []
    }
    

    
    
}
