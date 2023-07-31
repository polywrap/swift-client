//
//  Env.swift
//  
//
//  Created by Cesar Brazon on 29/7/23.
//

import Foundation
import PolywrapClient
import XCTest

public struct EnvObject: Codable, Equatable {
    public var prop: String
}

public struct Env: Codable, Equatable {
    public var str: String
    public var optStr: String?
    public var optFilledStr: String?
    public var number: Int
    public var optNumber: Int8?
    public var bool: Bool
    public var optBool: Bool?
    public var en: Int
    public var optEnum: Int8?
    public var object: EnvObject
    public var optObject: EnvObject?
    public var array: [Int]
}


func getDefaultEnv() -> Env {
    return Env(str: "string", optStr: "optional string", number: 10, bool: true, en: 0, object: EnvObject(prop: "object string"), array: [32, 32])
}

public struct Args: Codable {
    public var arg: String
}

final class EnvTests: XCTestCase {
    func testInvokeWithoutEnvDoesNotRequireEnv() throws {
        let uri = try Uri("wrap/env")
        let wrap = try getTestWrap(path: "env-type/00-main/implementations/rs")
        let client = BuilderConfig().addWrapper(uri, wrap).build()

        let result: String = try client.invoke(uri: uri, method: "methodNoEnv", args: Args(arg: "test"))
        XCTAssertEqual(result, "test")
    }
    
    func testInvokeWithRequiredEnvWorksWithEnvThroughBuilderConfig() throws {
        let uri = try Uri("wrap/env")
        let wrap = try getTestWrap(path: "env-type/00-main/implementations/as")
        let client = try BuilderConfig().addWrapper(uri, wrap).addEnv(uri, getDefaultEnv()).build()
        
        let result: Env = try client.invoke(uri: uri, method: "methodRequireEnv")
        XCTAssertEqual(result, getDefaultEnv())
    }
    
    func testInvokeWithRequiredEnvWorksWithEnvThroughInvocation() throws {
        let uri = try Uri("wrap/env")
        let wrap = try getTestWrap(path: "env-type/00-main/implementations/as")
        let client = BuilderConfig().addWrapper(uri, wrap).build()
        
        let result: Env = try client.invoke(uri: uri, method: "methodRequireEnv", env: getDefaultEnv())
        XCTAssertEqual(result, getDefaultEnv())
    }
}
