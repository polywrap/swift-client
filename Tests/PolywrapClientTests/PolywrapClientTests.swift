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
        let reader = ResourceReader(bundle: Bundle.module)
        let bytes = try reader.readFile("Cases/subinvoke")
        let embedded_wrapper = WasmWrapper(module: bytes)
        let uri = try Uri("wrap://wrap/embedded")
        let builder = BuilderConfig().addWrapper(uri, embedded_wrapper)
        let client = builder.build()
        let result: Int = try client.invoke(uri: uri, method: "add", args: AddArgs(a: 1, b: 2), env: nil)
        XCTAssertEqual(result, 3)
    }
    
    func testPluginInvoke() throws {
        let mockPlugin = MockPlugin(7)
        let wrapPackage = PluginPackage(mockPlugin)
        let uri = try Uri("wrap://plugin/mock")
        let builder = BuilderConfig().addPackage(uri, wrapPackage)
        let client = builder.build()
        let result: Int = try client.invoke(uri: uri, method: "add", args: AddArgs(a: 1, b: 2), env: nil)
        XCTAssertEqual(result, 3)
    }
    
    func testPluginStatefulInvoke() throws {
        let mockPlugin = MockPlugin(7)
        let wrapPackage = PluginPackage(mockPlugin)
        let uri = try Uri("wrap://plugin/mock")
        let builder = BuilderConfig().addPackage(uri, wrapPackage)
        let client = builder.build()

        let result: Int = try client.invoke(uri: uri, method: "plusOne", args: nil as PlusOneArgs?, env: nil)
        XCTAssertEqual(result, 8)
        let resultTwo: Int = try client.invoke(uri: uri, method: "plusOne", args: nil as PlusOneArgs?, env: nil)
        XCTAssertEqual(resultTwo, 9)
        let resultThree: Int = try client.invoke(uri: uri, method: "plusOne", args: nil as PlusOneArgs?, env: nil)
        XCTAssertEqual(resultThree, 10)
    }
}

