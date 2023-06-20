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
        guard let url = Bundle.module.url(forResource: "wrap", withExtension: "wasm") else {
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

    struct AddArgs: Codable {
        var a: Int
        var b: Int
        
        public init(a: Int, b: Int) {
            self.a = a
            self.b = b
        }
    }

    func testInvoke() throws {
        if let bytes = readModuleBytes() {
            let embedded_wrapper = WasmWrapper(module: bytes)
            let uri = Uri("wrap://wrap/embedded")!
//            let uri_wrapper = UriWrapper(uriValue: uri, wrap: embedded_wrapper)
//            let static_resolver = StaticResolver([
//                uri.ffi.toStringUri(): uri_wrapper
//            ])
            let builder = BuilderConfig()
            builder.addWrapper(uri, embedded_wrapper)
            let client = builder.build()
            let result: Int = try! client.invoke(uri: uri, method: "add", args: AddArgs(a: 1, b: 2), env: nil)
            XCTAssertEqual(result, 3)
        } else {
            fatalError("WASM Module not found")
        }
    }
}

