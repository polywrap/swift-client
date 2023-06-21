//
//  Plugin.swift
//  
//
//  Created by Cesar Brazon on 21/6/23.
//

import Foundation
import PolywrapClient

public class MockPlugin: PluginModule {
    let value: Int;
    
    public init(_ value: Int) {
        self.value = value
        super.init()
    }

    public func add(_ args: AddArgs) -> Int {
        args.a + args.b
    }
}


