//
//  InvalidType.swift
//
//
//  Created by Cesar Brazon on 30/7/23.
//

import XCTest
import PolywrapClient

internal func getClientWithInvalidType() throws -> (PolywrapClient, Uri) {
    let embeddedWrapper = try getTestWrap(path: "invalid-type/implementations/rs")
    let wrapUri = try Uri("wrap://wrap/invalid")
    let builder = BuilderConfig()
        .addWrapper(wrapUri, embeddedWrapper)
    return (builder.build(), wrapUri)
}

struct InvalidTypeBoolMethodArgs: Encodable {
    let arg: UInt32
}

struct InvalidTypeIntMethodArgs: Encodable {
    let arg: Bool
}

struct InvalidTypeUintMethodArgs: Encodable {
    let arg: [UInt32]
}

struct InvalidTypeBytesMethodArgs: Encodable {
    let arg: Float
}

struct InvalidTypeArrayMethodProp: Encodable {
    let prop: String
}

struct InvalidTypeArrayMethodArgs: Encodable {
    let arg: InvalidTypeArrayMethodProp
}

final class InvalidTypeTests: XCTestCase {
    func testInvalidType() throws {
        let (client, uri) = try getClientWithInvalidType()
        
        do {
            let _: Bool = try client.invoke(
                uri: uri,
                method: "boolMethod",
                args: InvalidTypeBoolMethodArgs(arg: 10)
            )
            XCTFail("Expected failure when providing invalid type for 'boolMethod', but invocation succeeded.")
        } catch FfiError.InvokeError(_, _, let err) {
            XCTAssertTrue(err.contains("Property must be of type 'bool'. Found 'int'."))
        }

        do {
            let _: Int = try client.invoke(
                uri: uri,
                method: "intMethod",
                args: InvalidTypeIntMethodArgs(arg: true)
            )
            XCTFail("Expected failure when providing invalid type for 'intMethod', but invocation succeeded.")
        } catch FfiError.InvokeError(_, _, let err) {
            XCTAssertTrue(err.contains("Property must be of type 'int'. Found 'bool'."))
        }

        do {
            let _: UInt32 = try client.invoke(
                uri: uri,
                method: "uIntMethod",
                args: InvalidTypeUintMethodArgs(arg: [10])
            )
            XCTFail("Expected failure when providing invalid type for 'uIntMethod', but invocation succeeded.")
        } catch FfiError.InvokeError(_, _, let err) {
            XCTAssertTrue(err.contains("Property must be of type 'uint'. Found 'array'."))
        }

        do {
            let _: [UInt8] = try client.invoke(
                uri: uri,
                method: "bytesMethod",
                args: InvalidTypeBytesMethodArgs(arg: 10.15)
            )
            XCTFail("Expected failure when providing invalid type for 'bytesMethod', but invocation succeeded.")
        } catch FfiError.InvokeError(_, _, let err) {
            XCTAssertTrue(err.contains("Property must be of type 'bytes'. Found 'float32'."))
        }

        do {
            let _: [Int32] = try client.invoke(
                uri: uri,
                method: "arrayMethod",
                args: InvalidTypeArrayMethodArgs(arg: InvalidTypeArrayMethodProp(prop: ""))
            )
            XCTFail("Expected failure when providing invalid type for 'arrayMethod', but invocation succeeded.")
        } catch FfiError.InvokeError(_, _, let err) {
            XCTAssertTrue(err.contains("Property must be of type 'array'. Found 'map'."))
        }
    }
}
