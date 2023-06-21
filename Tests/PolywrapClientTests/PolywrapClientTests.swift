//
//  PolywrapClientTests.swift
//  
//
//  Created by Cesar Brazon on 16/6/23.
//

import XCTest
@testable import PolywrapClient

public struct AddArgs: Codable {
    var a: Int
    var b: Int
    
    public init(a: Int, b: Int) {
        self.a = a
        self.b = b
    }
}

final class PolywrapClientTests: XCTestCase {
    func testWrapInvoke() throws {
        if let bytes = readModuleBytes() {
            let embedded_wrapper = WasmWrapper(module: bytes)
            let uri = Uri("wrap://wrap/embedded")!
            let builder = BuilderConfig()
            builder.addWrapper(uri, embedded_wrapper)
            let client = builder.build()
            let result: Int = try! client.invoke(uri: uri, method: "add", args: AddArgs(a: 1, b: 2), env: nil)
            XCTAssertEqual(result, 3)
        } else {
            fatalError("WASM Module not found")
        }
    }
    
    func testPluginInvoker() throws {
        let mockPlugin = MockPlugin(7)
        let wrapPackage = PluginPackage(mockPlugin)
        let uri = Uri("wrap://plugin/mock")!
        let builder = BuilderConfig()
        builder.addPackage(uri, wrapPackage)
        let client = builder.build()
        let t: Int? = try? client.invoke(uri: uri, method: "add", args: AddArgs(a: 1, b: 2), env: nil)
        print(t)
    }
}

