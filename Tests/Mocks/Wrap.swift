//
//  Wrap.swift
//  
//
//  Created by Cesar Brazon on 17/7/23.
//

import Foundation
import PolywrapClient

public class MockWrap: IffiWrapper {
    public func invoke(method: String, args: [UInt8]?, env: [UInt8]?, invoker: FfiInvoker) throws -> [UInt8] {
        // In msgpack: True = [195] and False = [194]
        if method == "foo" {
            return [195]
        } else {
            return [194]
        }
    }
    
    
}
