//
//  Numbers.swift
//
//
//  Created by Cesar Brazon on 30/7/23.
//

import XCTest
import PolywrapClient

internal func getClientWithNumberType() throws -> (PolywrapClient, Uri) {
    let embeddedWrapper = try getTestWrap(path: "numbers-type/implementations/rs")
    let wrapUri = try Uri("wrap://wrap/numbers")
    let builder = BuilderConfig()
        .addWrapper(wrapUri, embeddedWrapper)
    return (builder.build(), wrapUri)
}

struct NumberMethodArgs: Encodable {
    let first: Int64
    let second: Int64
}

final class NumberTypeTests: XCTestCase {
    func testNumberType() throws {
        let (client, uri) = try getClientWithNumberType()
        
        do {
            let _: Int8 = try client.invoke(
                uri: uri,
                method: "i8Method",
                args: NumberMethodArgs(first: -129, second: 10)
            )
            XCTFail("Expected failure when providing overflow value for 'i8Method', but invocation succeeded.")
        } catch FfiError.InvokeError(_, _, let err) {
            XCTAssertTrue(err.contains("integer overflow"))
        }

        do {
            let _: UInt8 = try client.invoke(
                uri: uri,
                method: "u8Method",
                args: NumberMethodArgs(first: 256, second: 10)
            )
            XCTFail("Expected failure when providing overflow value for 'u8Method', but invocation succeeded.")
        } catch FfiError.InvokeError(_, _, let err) {
            XCTAssertTrue(err.contains("unsigned integer overflow"))
        }

        do {
            let _: Int16 = try client.invoke(
                uri: uri,
                method: "i16Method",
                args: NumberMethodArgs(first: -32769, second: 10)
            )
            XCTFail("Expected failure when providing overflow value for 'i16Method', but invocation succeeded.")
        } catch FfiError.InvokeError(_, _, let err) {
            XCTAssertTrue(err.contains("integer overflow"))
        }

        do {
            let _: UInt16 = try client.invoke(
                uri: uri,
                method: "u16Method",
                args: NumberMethodArgs(first: 65536, second: 10)
            )
            XCTFail("Expected failure when providing overflow value for 'u16Method', but invocation succeeded.")
        } catch FfiError.InvokeError(_, _, let err) {
            XCTAssertTrue(err.contains("unsigned integer overflow"))
        }

        do {
            let _: Int32 = try client.invoke(
                uri: uri,
                method: "i32Method",
                args: NumberMethodArgs(first: -2147483649, second: 10)
            )
            XCTFail("Expected failure when providing overflow value for 'i32Method', but invocation succeeded.")
        } catch FfiError.InvokeError(_, _, let err) {
            XCTAssertTrue(err.contains("integer overflow"))
        }

        do {
            let _: UInt32 = try client.invoke(
                uri: uri,
                method: "u32Method",
                args: NumberMethodArgs(first: 4294967296, second: 10)
            )
            XCTFail("Expected failure when providing overflow value for 'u32Method', but invocation succeeded.")
        } catch FfiError.InvokeError(_, _, let err) {
            XCTAssertTrue(err.contains("unsigned integer overflow"))
        }
    }
}
