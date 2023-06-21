//
//  Utils.swift
//  
//
//  Created by Cesar Brazon on 21/6/23.
//

import Foundation

public func readModuleBytes() -> [UInt8]? {
    guard let url = Bundle.module.url(forResource: "wrap", withExtension: "wasm", subdirectory: "Cases/subinvoke") else {
        print("File not found")
        return nil
    }
    do {
        let data = try Data(contentsOf: url)
        var byteArray = [UInt8](repeating: 0, count: data.count)
        data.copyBytes(to: &byteArray, count: data.count)
        return byteArray
    } catch {
        print("Unable to load file: \(error)")
        return nil
    }
}
