//
//  PolywrapClientTests.swift
//  
//
//  Created by Cesar Brazon on 16/6/23.
//

import XCTest
@testable import PolywrapClient

struct EmptyResponse:Codable {}
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

        mockPlugin.addMethod(name: "add", closure: mockPlugin.add)

        let wrapPackage = PluginPackage(mockPlugin)
        let uri = try Uri("wrap://plugin/mock")
        let builder = BuilderConfig().addPackage(uri, wrapPackage)
        let client = builder.build()
        let result: Int = try client.invoke(uri: uri, method: "add", args: AddArgs(a: 1, b: 2), env: nil)
        XCTAssertEqual(result, 3)
    }
    
    func testPluginStatefulInvoke() throws {
        let mockPlugin = MockPlugin(7)
        mockPlugin.addVoidMethod(name: "increment", closure: mockPlugin.increment)

        let wrapPackage = PluginPackage(mockPlugin)
        let uri = try Uri("wrap://plugin/mock")
        let builder = BuilderConfig().addPackage(uri, wrapPackage)
        let client = builder.build()

        let _: VoidCodable? = try client.invoke(uri: uri, method: "increment")
        XCTAssertEqual(mockPlugin.counter, 8)
        let _: VoidCodable? = try client.invoke(uri: uri, method: "increment")
        XCTAssertEqual(mockPlugin.counter, 9)
        let _: VoidCodable? = try client.invoke(uri: uri, method: "increment")
        XCTAssertEqual(mockPlugin.counter, 10)
    }
}

