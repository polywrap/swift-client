//
//  PluginPackage.swift
//  
//
//  Created by Cesar Brazon on 21/6/23.
//

import Foundation
import PolywrapClientNativeLib

/// Represents a plugin package that can create a wrapper for a plugin module. 
public class PluginPackage: FfiWrapPackage {

    /// The instance of the `PluginModule` to be wrapped.
    let module: PluginModule

    /// Creates a new instance of `PluginPackage`.
    ///
    /// - Parameter module: The `PluginModule` instance to wrap.
    public init(_ module: PluginModule) {
        self.module = module
    }

    /// Creates a wrapper for the `PluginModule`.
    ///
    /// - Returns: An `FfiWrapper` instance that wraps the `PluginModule`.
    /// - Throws: Rethrows errors from the `PluginWrapper` initializer.
    public func createWrapper() throws -> FfiWrapper {
        PluginWrapper(self.module)
    }
}
