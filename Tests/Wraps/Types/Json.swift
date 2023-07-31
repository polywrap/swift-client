//
//  Json.swift
//
//
//  Created by Cesar Brazon on 30/7/23.
//

import XCTest
import PolywrapClient

internal func getClientWithJsonType() throws -> (PolywrapClient, Uri) {
    let embeddedWrapper = try getTestWrap(path: "json-type/implementations/rs")
    let wrapUri = try Uri("wrap://wrap/json")
    let builder = BuilderConfig()
        .addWrapper(wrapUri, embeddedWrapper)
    return (builder.build(), wrapUri)
}

struct StringifyArgs: Encodable {
    let values: [String]
}

struct ParseArgs: Encodable {
    let value: String
}

struct StringifyObjectArgs: Encodable {
    let object: Object
}

struct Object: Encodable {
    let jsonA: String
    let jsonB: String
}

struct MethodJSONArgs: Encodable {
    let valueA: Int64
    let valueB: String
    let valueC: Bool
}

struct ParseReservedArgs: Encodable {
    let json: String
}

struct StringifyReservedArgs: Encodable {
    let reserved: Reserved
}

struct Reserved: Codable, Equatable {
    let const: String
    let `if`: Bool
}

final class JsonTypeTests: XCTestCase {
    func testJsonType() throws {
        let (client, uri) = try getClientWithJsonType()
        
        // Parse
        let jsonValue = "{\"foo\":\"bar\",\"bar\":\"bar\"}"
        let parsed: String = try client.invoke(
            uri: uri,
            method: "parse",
            args: ParseArgs(value: jsonValue)
        )
        XCTAssertEqual(parsed, jsonValue)
        
        // Stringify
        let stringifyValues = ["{\"bar\":\"foo\"}", "{\"baz\":\"fuz\"}"]
        let stringified: String = try client.invoke(
            uri: uri,
            method: "stringify",
            args: StringifyArgs(values: stringifyValues)
        )
        XCTAssertEqual(stringified, "{\"bar\":\"foo\"}{\"baz\":\"fuz\"}")
        
        // StringifyObject
        let object = Object(jsonA: "{\"foo\":\"bar\"}", jsonB: "{\"fuz\":\"baz\"}")
        let stringifiedObject: String = try client.invoke(
            uri: uri,
            method: "stringifyObject",
            args: StringifyObjectArgs(object: object)
        )
        XCTAssertEqual(stringifiedObject, object.jsonA + object.jsonB)
        
        // MethodJSON
        let methodJsonArgs = MethodJSONArgs(valueA: 5, valueB: "foo", valueC: true)
        let jsonMethod: String = try client.invoke(
            uri: uri,
            method: "methodJSON",
            args: methodJsonArgs
        )
        XCTAssertEqual(jsonMethod, "{\"valueA\":5,\"valueB\":\"foo\",\"valueC\":true}")
        
        // ParseReserved
        let reservedJson = "{\"const\":\"hello\",\"if\":true}"
        let parsedReserved: Reserved = try client.invoke(
            uri: uri,
            method: "parseReserved",
            args: ParseReservedArgs(json: reservedJson)
        )
        XCTAssertEqual(parsedReserved, Reserved(const: "hello", if: true))
        
        // StringifyReserved
        let stringifyReservedArgs = StringifyReservedArgs(reserved: Reserved(const: "hello", if: true))
        let stringifyReserved: String = try client.invoke(
            uri: uri,
            method: "stringifyReserved",
            args: stringifyReservedArgs
        )
        XCTAssertEqual(stringifyReserved, reservedJson)
    }
}
