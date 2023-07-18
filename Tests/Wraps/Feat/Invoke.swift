//
//  Invoke.swift
//  
//
//  Created by Cesar Brazon on 5/7/23.
//

import Foundation
import XCTest
import PolywrapClient

final class InvokeTests: XCTestCase {
    func testWrapInvoke() throws {
        let reader = ResourceReader(bundle: Bundle.module)
        let bytes = try reader.readFile("Cases/subinvoke/00-subinvoke/implementations/as")
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
        
        let _: VoidCodable? = try? client.invoke(uri: uri, method: "increment")
        XCTAssertEqual(mockPlugin.counter, 8)
        let _: VoidCodable? = try client.invoke(uri: uri, method: "increment")
        XCTAssertEqual(mockPlugin.counter, 9)
        let _: VoidCodable? = try client.invoke(uri: uri, method: "increment")
        XCTAssertEqual(mockPlugin.counter, 10)
    }
    
    func testPluginAsyncInvoke() throws {
        let memoryStoragePlugin = MemoryStoragePlugin()
        memoryStoragePlugin.addAsyncMethod(name: "getData", closure: memoryStoragePlugin.getData)
        memoryStoragePlugin.addAsyncMethod(name: "setData", closure: memoryStoragePlugin.setData)
        
        let wrapPackage = PluginPackage(memoryStoragePlugin)
        let uri = try Uri("wrap://plugin/memory-storage")
        let builder = BuilderConfig().addPackage(uri, wrapPackage)
        let client = builder.build()
        
        let result: Bool = try client.invoke(uri: uri, method: "setData", args: SetDataArgs(5000), env: nil)
        XCTAssertEqual(result, true)
        let data: Int = try client.invoke(uri: uri, method: "getData")
        XCTAssertEqual(data, 5000)
    }
}
