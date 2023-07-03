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

public struct Env: Codable {}
public struct PlusOneArgs: Codable {}

public class MockPlugin: PluginModule {
    var counter = 0
    public init(_ value: Int) {
        super.init()
        super.addMethod(name: "add", closure: add)
        super.addMethod(name: "plusOne", closure: plusOne)
        self.counter = value
    }
    
    public func add(_ args: AddArgs, _ env: Env?, _ invoker: FfiInvoker) -> Int {
        return args.a + args.b
    }
    
    public func plusOne(_ args: PlusOneArgs?, _ env: Env?, _ invoker: FfiInvoker) -> Int {
        self.counter += 1
        return self.counter
    }
}


