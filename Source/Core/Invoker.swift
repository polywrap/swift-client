//
//  Invoker.swift
//  
//
//  Created by Cesar Brazon on 4/7/23.
//

import Foundation
import PolywrapClientNativeLib

public class Invoker {
    let ffi: FfiInvoker

    public init(_ ffi: FfiInvoker) {
        self.ffi = ffi
    }

    public func invoke(
        uri: Uri,
        method: String,
        args: [UInt8]?,
        env: [UInt8]?,
        resolutionContext: FfiUriResolutionContext?
    ) throws -> [UInt8] {
        return try self.ffi.invokeRaw(
            uri: uri.ffi,
            method: method,
            args: args,
            env: env,
            resolutionContext: resolutionContext
        )
    }
}
