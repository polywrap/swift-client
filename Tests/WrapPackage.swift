//
//  WrapPackage.swift
//  
//
//  Created by Cesar Brazon on 18/7/23.
//

import XCTest
import Foundation
import PolywrapClient

class WrapPackageTests: XCTestCase {
    let reader = ResourceReader(bundle: Bundle.module, path: "Cases/subinvoke/00-subinvoke/implementations/as")
    func testWrapPackage() throws {
        let package = WasmPackage(reader: reader, module: nil)
        let wrapper = try package.createWrapper()
        XCTAssert(wrapper is WasmWrapper)  // Ensure the type is correct.
    }
    
    func testGetModuleThrowsWhenReaderMissing() {
        let package = WasmPackage(reader: nil, module: nil)
        XCTAssertThrowsError(try package.getModule()) { error in
            XCTAssertEqual(error as? WasmPackageError, WasmPackageError.readerMissing)
        }
    }
    
    func testGetModuleReturnsStoredModule() throws {
        let expectedModule = [UInt8](arrayLiteral: 1, 2, 3)
        let package = WasmPackage(reader: nil, module: expectedModule)
        let returnedModule = try package.getModule()
        XCTAssertEqual(expectedModule, returnedModule)
    }
}
