//
//  BigNumber.swift
//
//
//  Created by Cesar Brazon on 30/7/23.
//

import XCTest
import PolywrapClient

internal func getClientWithBigNumber() throws -> (PolywrapClient, Uri) {
    let embeddedWrapper = try getTestWrap(path: "bignumber-type/implementations/rs")
    let wrapUri = try Uri("wrap/bignumber")
    let builder = BuilderConfig()
        .addWrapper(wrapUri, embeddedWrapper)
    return (builder.build(), wrapUri)
}

struct MethodBigNumberArgs: Encodable {
    let arg1: String
    let arg2: String?
    let obj: ArgsBigNumberObject
}

struct ArgsBigNumberObject: Encodable {
    let prop1: String
    let prop2: String?
}

final class BigNumberTest: XCTestCase {

    func testMethodWithoutOptionalArguments() throws {
        let (client, uri) = try getClientWithBigNumber()
        let args = MethodBigNumberArgs(
            arg1: "1234.56789123456789",
            arg2: nil,
            obj: ArgsBigNumberObject(prop1: "98.7654321987654321", prop2: nil)
        )
        let response: String = try client.invoke(
            uri: uri,
            method: "method",
            args: args
        )

        XCTAssertEqual(response, "121932.631356500531347203169112635269")
    }

    func testMethodWithOptionalArguments() throws {
        let (client, uri) = try getClientWithBigNumber()
        let args = MethodBigNumberArgs(
            arg1: "1234567.89123456789",
            arg2: "123456789123.456789123456789123456789",
            obj: ArgsBigNumberObject(
                prop1: "987654.321987654321",
                prop2: "987.654321987654321987654321987654321"
            )
        )
        let response: String = try client.invoke(
            uri: uri,
            method: "method",
            args: args
        )
        XCTAssertEqual(response, "148675665895202566369526758.32761810042052714954475733921339294591449425189993314702917605688621625822702361")
    }
}
