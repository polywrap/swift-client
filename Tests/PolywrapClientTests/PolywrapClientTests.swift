//
//  PolywrapClientTests.swift
//  
//
//  Created by Cesar Brazon on 16/6/23.
//

import XCTest
@testable import PolywrapClient

final class PolywrapClientTests: XCTestCase {
    func testWrapInvoke() throws {
        if let bytes = fileReader(Bundle.module, "Cases/subinvoke") {
            let embedded_wrapper = WasmWrapper(module: bytes)
            let uri = try Uri("wrap://wrap/embedded")
            let builder = BuilderConfig()
            builder.addWrapper(uri, embedded_wrapper)
            let client = builder.build()
            let result: Int = try client.invoke(uri: uri, method: "add", args: AddArgs(a: 1, b: 2), env: nil)
            XCTAssertEqual(result, 3)
        } else {
            fatalError("WASM Module not found")
        }
    }
    
    func testPluginInvoker() throws {
        let mockPlugin = MockPlugin(7)
        let wrapPackage = PluginPackage(mockPlugin)
        let uri = try Uri("wrap://plugin/mock")
        let builder = BuilderConfig()
        builder.addPackage(uri, wrapPackage)
        let client = builder.build()
        let result: Int = try client.invoke(uri: uri, method: "add", args: AddArgs(a: 1, b: 2), env: nil)
        XCTAssertEqual(result, 3)
    }
}

