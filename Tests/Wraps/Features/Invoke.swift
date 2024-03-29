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
        let wrap = try getTestWrap(path: "subinvoke/00-subinvoke/implementations/as")
        let uri = try Uri("wrap://wrap/embedded")
        let builder = BuilderConfig().addWrapper(uri, wrap)
        let client = builder.build()
        let result: Int = try client.invoke(uri: uri, method: "add", args: AddArgs(a: 1, b: 2))
        XCTAssertEqual(result, 3)
    }
    
    func testPluginInvoke() throws {
        var mockPlugin = MockPlugin(7)
        mockPlugin.addMethod(name: "add", closure: mockPlugin.add)

        let wrapPackage = PluginPackage(mockPlugin)
        let uri = try Uri("wrap://plugin/mock")
        let builder = BuilderConfig().addPackage(uri, wrapPackage)
        let client = builder.build()
        let result: Int = try client.invoke(uri: uri, method: "add", args: AddArgs(a: 1, b: 2))
        XCTAssertEqual(result, 3)
    }
    
    func testPluginStatefulInvoke() throws {
        var mockPlugin = MockPlugin(7)
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
        var memoryStoragePlugin = MemoryStoragePlugin()
        memoryStoragePlugin.addMethod(name: "getData", closure: memoryStoragePlugin.getData)
        memoryStoragePlugin.addMethod(name: "setData", closure: memoryStoragePlugin.setData)

        let wrapPackage = PluginPackage(memoryStoragePlugin)
        let uri = try Uri("wrap://plugin/memory-storage")
        let builder = BuilderConfig().addPackage(uri, wrapPackage)
        let client = builder.build()

        let result: Bool = try client.invoke(uri: uri, method: "setData", args: SetDataArgs(5000))
        XCTAssertEqual(result, true)
        let data: Int = try client.invoke(uri: uri, method: "getData")
        XCTAssertEqual(data, 5000)
    }
    
    func testSubinvoke() throws {
        let embeddedSubinvokeWrap = try getTestWrap(path: "subinvoke/00-subinvoke/implementations/as")
        let subinvokeWrapUri = try Uri("wrap://wrap/subinvoke")

        let embeddedInvokeWrap = try getTestWrap(path: "subinvoke/01-invoke/implementations/as")
        let invokeWrapUri = try Uri("wrap://wrap/invoke")

        let builder = BuilderConfig()
            .addWrapper(subinvokeWrapUri, embeddedSubinvokeWrap)
            .addWrapper(invokeWrapUri, embeddedInvokeWrap)
            .addRedirect(try Uri("authority/imported-subinvoke"), subinvokeWrapUri)

        let client = builder.build()
        let result: Int = try client.invoke(uri: invokeWrapUri, method: "addAndIncrement", args: AddArgs(a: 1, b: 1))
        XCTAssertEqual(result, 3)
    }

    func testInvokeRaw() throws {
        let wrap = try getTestWrap(path: "subinvoke/00-subinvoke/implementations/as")
        let uri = try Uri("wrap://wrap/embedded")
        let builder = BuilderConfig().addWrapper(uri, wrap)
        let client = builder.build()

        let encodedArgs = try encode(value: AddArgs(a: 1, b: 1))
        let result = try client.invokeRaw(uri: uri, method: "add", args: encodedArgs, env: nil)
        XCTAssertEqual(result, [2])
    }
}
