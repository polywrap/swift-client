//
//  Utils.swift
//  
//
//  Created by Cesar Brazon on 29/7/23.
//

import Foundation
import PolywrapClient

public func getTestWrap(path: String) throws -> WasmWrapper {
    let reader = ResourceReader(bundle: Bundle.module)
    let bytes = try reader.readFile("Cases/" + path)
    return try WasmWrapper(module: bytes)
}
