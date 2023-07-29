//
//  Interfaces.swift
//  
//
//  Created by Cesar Brazon on 29/7/23.
//

import Foundation
import PolywrapClient
import XCTest

public struct MethodResponse: Codable, Equatable {
    public var uint8: UInt8
    public var str: String
}

struct ModuleMethodArgs: Codable {
    public var arg: MethodResponse
}

final class InterfaceImplementationTests: XCTestCase {
    func testInterfaceImplementations() throws {
        let implementation = try getTestWrap(path: "interface-invoke/01-implementation/implementations/rs")
        let wrap = try getTestWrap(path: "interface-invoke/02-wrapper/implementations/rs")
        let implementationUri = try Uri("wrap/implementation")
        let wrapUri = try Uri("wrap/consumer")
        let client = BuilderConfig()
            .addInterfaceImplementation(try Uri("authority/interface"), implementationUri)
            .addWrapper(implementationUri, implementation)
            .addWrapper(wrapUri, wrap)
            .build()
        
        let mockResponse = MethodResponse(uint8: 1, str: "foo")
        let response: MethodResponse = try client.invoke(uri: wrapUri, method: "moduleMethod", args: ModuleMethodArgs(arg: mockResponse))
        XCTAssertEqual(response, mockResponse)
    }
}

