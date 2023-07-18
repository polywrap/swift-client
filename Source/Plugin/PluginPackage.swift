//
//  PluginPackage.swift
//  
//
//  Created by Cesar Brazon on 21/6/23.
//

import Foundation
import PolywrapClientNativeLib

public class PluginPackage: FfiWrapPackage {
    let module: PluginModule

    public init(_ module: PluginModule) {
        self.module = module
    }

    public func createWrapper() throws -> FfiWrapper {
        PluginWrapper(self.module)
    }
}
