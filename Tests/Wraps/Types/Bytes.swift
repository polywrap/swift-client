//
//  Bytes.swift
//
//
//  Created by Cesar Brazon on 30/7/23.
//

import XCTest
import PolywrapClient

internal func getClientWithBytes() throws -> (PolywrapClient, Uri) {
    let embeddedWrapper = try getTestWrap(path: "bytes-type/implementations/rs")
    let wrapUri = try Uri("wrap/bytes")
    let builder = BuilderConfig()
        .addWrapper(wrapUri, embeddedWrapper)
    return (builder.build(), wrapUri)
}

struct BytesMethodArgs: Encodable {
    let arg: BytesArgs
}

struct BytesArgs: Encodable {
    let prop: Data
}

final class BytesTest: XCTestCase {
    func testBytesMethod() throws {
        let (client, uri) = try getClientWithBytes()
        let args = BytesMethodArgs(
            arg: BytesArgs(
                prop: "Argument Value".data(using: .utf8)!
            )
        )
        let response: Data = try client.invoke(
            uri: uri,
            method: "bytesMethod",
            args: args
        )

        let expected = "Argument Value Sanity!".data(using: .utf8)!
        XCTAssertEqual(response, expected)
    }
}
