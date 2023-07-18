//
//  Invoker.swift
//  
//
//  Created by Cesar Brazon on 18/7/23.
//

import Foundation
import PolywrapClientNativeLib

public class MockInvoker: FFIInvokerProtocol {
    public func invokeRaw(uri: PolywrapClientNativeLib.FfiUri, method: String, args: [UInt8]?, env: [UInt8]?, resolutionContext: PolywrapClientNativeLib.FfiUriResolutionContext?) throws -> [UInt8] {
        if method == "foo" {
            return [195]
        } else {
            return [194]
        }
    }
    
    public func getImplementations(uri: PolywrapClientNativeLib.FfiUri) throws -> [PolywrapClientNativeLib.FfiUri] {
        return []
    }
    
    public func getInterfaces() -> [String : [PolywrapClientNativeLib.FfiUri]]? {
        return [:]
    }
    
    public func getEnvByUri(uri: PolywrapClientNativeLib.FfiUri) -> [UInt8]? {
        return []
    }
    

    
    
}
