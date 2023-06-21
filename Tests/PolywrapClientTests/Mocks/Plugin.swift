//
//  Plugin.swift
//  
//
//  Created by Cesar Brazon on 21/6/23.
//

import Foundation
import PolywrapClient

public struct AddArgs: Codable {
    var a: Int
    var b: Int
    
    public init(a: Int, b: Int) {
        self.a = a
        self.b = b
    }
}

public class MockPlugin: PluginModule {
    public init(_ value: Int) {
        super.init()
        super.addMethod(name: "add", closure: add)
    }
    
    public func add(_ args: AddArgs, _ env: Codable?, _ invoker: FfiInvoker) -> Int {
        return args.a + args.b
    }
}


