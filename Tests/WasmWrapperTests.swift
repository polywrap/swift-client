//
//  WasmWrapperTests.swift
//  
//
//  Created by Cesar Brazon on 18/8/23.
//


import XCTest
import Foundation
@testable import PolywrapClient

class WasmWrapperTests: XCTestCase {
    func testWasmWrapperInitFailsWithWrongWasmModule() {
        XCTAssertThrowsError(try WasmWrapper(module: [1])) { error in
            XCTAssertEqual(error as? WasmWrapperError, WasmWrapperError.fromBytecodeError)
        }
    }
    
    func testInvoke() throws {
        let client = BuilderConfig().build()
        let invoker = client.ffi.asInvoker()
        let wrap = try getTestWrap(path: "subinvoke/00-subinvoke/implementations/as")
        let result = try wrap.invoke(method: "add", args: try encode(value: AddArgs(a: 1, b: 2)), env: nil, invoker: invoker)
        XCTAssertEqual(result, [3])
    }
}
