//
//  BigInt.swift
//
//
//  Created by Cesar Brazon on 30/7/23.
//

import XCTest
import PolywrapClient

internal func getClientWithBigint() throws -> (PolywrapClient, Uri) {
    let embeddedWrapper = try getTestWrap(path: "bigint-type/implementations/rs")
    let wrapUri = try Uri("wrap/bigint")
    let builder = BuilderConfig()
        .addWrapper(wrapUri, embeddedWrapper)
    return (builder.build(), wrapUri)
}

struct MethodBigIntArgs: Encodable {
    let arg1: String
    let arg2: String?
    let obj: ArgsBigIntObject
}

struct ArgsBigIntObject: Encodable {
    let prop1: String
    let prop2: String?
}

final class BigIntTest: XCTestCase {
    func testMethodWithoutOptionalArguments() throws {
        let (client, uri) = try getClientWithBigint()
        
        let args = MethodBigIntArgs(
            arg1: "123456789123456789",
            arg2: nil,
            obj: ArgsBigIntObject(
                prop1: "987654321987654321",
                prop2: nil
            )
        )
        
        let response: String = try client.invoke(uri: uri, method: "method", args: args)
        XCTAssertEqual(response, "121932631356500531347203169112635269")
    }
    
    func testMethodWithOptionalArguments() throws {
        let (client, uri) = try getClientWithBigint()
        
        let args = MethodBigIntArgs(
            arg1: "123456789123456789",
            arg2: "123456789123456789123456789123456789",
            obj: ArgsBigIntObject(
                prop1: "987654321987654321",
                prop2: "987654321987654321987654321987654321"
            )
        )
        
        let response: String = try client.invoke(uri: uri, method: "method", args: args)
        XCTAssertEqual(response, "14867566589520256636952675832761810042052714954475733921339294591449425189993314702917605688621625822702361")
    }
}
