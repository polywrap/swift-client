//
//  Object.swift
//
//
//  Created by Cesar Brazon on 31/7/23.
//

import XCTest
import PolywrapClient

internal func getClientWithObjectType() throws -> (PolywrapClient, Uri) {
    let embeddedWrapper = try getTestWrap(path: "object-type/implementations/rs")
    let wrapUri = try Uri("wrap://wrap/objects")
    let builder = BuilderConfig()
        .addWrapper(wrapUri, embeddedWrapper)
    return (builder.build(), wrapUri)
}

struct ObjectTypeNested: Codable, Equatable {
    let prop: String
}

struct ObjectTypeArg1: Encodable {
    let prop: String?
    let nested: ObjectTypeNested
}

struct ObjectTypeArg2: Encodable {
    let prop: String
    let circular: ObjectTypeNested
}

struct ObjectTypeArg3: Encodable {
    let prop: [UInt8]
}

struct ObjectTypeMethodOneArgs: Encodable {
    let arg1: ObjectTypeArg1
    let arg2: ObjectTypeArg2?
}

struct ObjectTypeMethodTwoArgs: Encodable {
    let arg: ObjectTypeArg1
}

struct ObjectTypeMethodThreeArgs: Encodable {
    let arg: ObjectTypeArg3
}

struct ObjectTypeOutput: Codable, Equatable {
    let prop: String
    let nested: ObjectTypeNested
}

final class ObjectTypeTests: XCTestCase {
    func testWithoutOptionalArgumentAndReturnArrayOfObject() throws {
        let (client, uri) = try getClientWithObjectType()
        let arg1 = ObjectTypeArg1(prop: "arg1 prop", nested: ObjectTypeNested(prop: "arg1 nested prop"))
        let args = ObjectTypeMethodOneArgs(arg1: arg1, arg2: nil)

        let response: [ObjectTypeOutput] = try client.invoke(uri: uri, method: "method1", args: args)
        XCTAssertEqual(response, [
            ObjectTypeOutput(prop: "arg1 prop", nested: ObjectTypeNested(prop: "arg1 nested prop")),
            ObjectTypeOutput(prop: "", nested: ObjectTypeNested(prop: "")),
        ])
    }

    func testWithOptionalArgumentAndReturnArrayOfObject() throws {
        let (client, uri) = try getClientWithObjectType()
        let arg1 = ObjectTypeArg1(prop: "arg1 prop", nested: ObjectTypeNested(prop: "arg1 nested prop"))
        let arg2 = ObjectTypeArg2(prop: "arg2 prop", circular: ObjectTypeNested(prop: "arg2 circular prop"))
        let args = ObjectTypeMethodOneArgs(arg1: arg1, arg2: arg2)

        let response: [ObjectTypeOutput] = try client.invoke(uri: uri, method: "method1", args: args)
        XCTAssertEqual(response, [
            ObjectTypeOutput(prop: "arg1 prop", nested: ObjectTypeNested(prop: "arg1 nested prop")),
            ObjectTypeOutput(prop: "arg2 prop", nested: ObjectTypeNested(prop: "arg2 circular prop")),
        ])
    }

    func testReturnsOptionalReturnValue() throws {
        let (client, uri) = try getClientWithObjectType()
        let arg = ObjectTypeArg1(prop: "arg1 prop", nested: ObjectTypeNested(prop: "arg1 nested prop"))
        let args = ObjectTypeMethodTwoArgs(arg: arg)

        let response: ObjectTypeOutput = try client.invoke(uri: uri, method: "method2", args: args)
        XCTAssertEqual(response, ObjectTypeOutput(prop: "arg1 prop", nested: ObjectTypeNested(prop: "arg1 nested prop")))
    }

    func testDoNotReturnsOptionalReturnValue() throws {
        let (client, uri) = try getClientWithObjectType()
        let arg = ObjectTypeArg1(prop: "null", nested: ObjectTypeNested(prop: "arg nested prop"))
        let args = ObjectTypeMethodTwoArgs(arg: arg)

        let response: ObjectTypeOutput? = try client.invoke(uri: uri, method: "method2", args: args)
        XCTAssertNil(response)

    }

    func testNotOptionalArgsAndReturnsNotOptionalArrayOfObjects() throws {
        let (client, uri) = try getClientWithObjectType()
        let arg = ObjectTypeArg1(prop: "arg prop", nested: ObjectTypeNested(prop: "arg nested prop"))
        let args = ObjectTypeMethodTwoArgs(arg: arg)

        let response: [ObjectTypeOutput?] = try client.invoke(uri: uri, method: "method3", args: args)
        XCTAssertEqual(response, [
            nil,
            ObjectTypeOutput(prop: "arg prop", nested: ObjectTypeNested(prop: "arg nested prop"))
        ])
    }

    func testNotOptionalArgsAndReturnsNotOptionalObject() throws {
        let (client, uri) = try getClientWithObjectType()
        let arg = ObjectTypeArg3(prop: [49, 50, 51, 52])
        let args = ObjectTypeMethodThreeArgs(arg: arg)

        let response: ObjectTypeOutput = try client.invoke(uri: uri, method: "method4", args: args)
        XCTAssertEqual(response, ObjectTypeOutput(prop: "1234", nested: ObjectTypeNested(prop: "nested prop")))
    }
}
