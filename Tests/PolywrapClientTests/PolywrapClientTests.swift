//
//  PolywrapClientTests.swift
//  
//
//  Created by Cesar Brazon on 16/6/23.
//

import XCTest
import PolywrapClient


final class PolywrapClientTests: XCTestCase {
    
    func readModuleBytes() -> [UInt8]? {
        guard let url = Bundle.main.url(forResource: "wrap", withExtension: "wasm", subdirectory: "subinvoke") else {
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


    func testInvoke() throws {
        if let bytes = readModuleBytes() {
            print("modules read!")
            print(bytes)
            let embedded_wrapper = WasmWrapper(module: bytes)
//            let static_resolver = StaticResolver([
//              uri: embedded_wrapper
//            ])
//            let config = ClientConfig(
//              resolver: static_resolver,
//              interfaces: nil,
//              env: nil
//            )
//            let client = PolywrapClient(config)
        } else {
            // handle error or file not found
        }
//        let wasmModuleBytes: [UInt8] = [0]
//        let embedded_wrapper = WasmPackage(module: wasmModuleBytes)
//        let static_resolver = StaticResolver([
//          uri: embedded_wrapper
//        ])
//        let config = ClientConfig(
//          resolver: static_resolver,
//          interfaces: nil,
//          env: nil
//        )
//        let client = PolywrapClient(config)
    }
}

