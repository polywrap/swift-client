//
//  Map.swift
//
//
//  Created by Cesar Brazon on 30/7/23.
//

import XCTest
import PolywrapClient

struct ArgsGetKey: Encodable {
    let foo: CustomMap
    let key: String
}

struct ArgsReturnMap: Encodable {
    let map: [String: UInt32]
}

struct ArgsReturnCustomMap: Encodable {
    let foo: CustomMap
}

struct ArgsReturnNestedMap: Encodable {
    let foo: [String: [String: UInt32]]
}

struct CustomMap: Codable, Equatable {
    let map: [String: UInt32]
    let nestedMap: [String: [String: UInt32]]
}

final class MapTypeTests: XCTestCase {
    internal func getClientWithMapType() throws -> (PolywrapClient, Uri) {
        let embeddedWrapper = try getTestWrap(path: "map-type/implementations/rs")
        let wrapUri = try Uri("wrap://wrap/map")
        let builder = BuilderConfig()
            .addWrapper(wrapUri, embeddedWrapper)
        return (builder.build(), wrapUri)
    }

    func createCustomMap() -> CustomMap {
        var map: [String: UInt32] = [:]
        map["Hello"] = 1
        map["Heyo"] = 50

        var nestedMap: [String: [String: UInt32]] = [:]
        nestedMap["Nested"] = map

        return CustomMap(map: map, nestedMap: nestedMap)
    }

    func testMapType() throws {
        let (client, uri) = try getClientWithMapType()

        // getKey
        let customMap = createCustomMap()
        let getKey: UInt32 = try client.invoke(
            uri: uri,
            method: "getKey",
            args: ArgsGetKey(foo: customMap, key: "Hello")
        )
        XCTAssertEqual(getKey, 1)

        // returnMap
        let returnedMap: [String: UInt32] = try client.invoke(
            uri: uri,
            method: "returnMap",
            args: ArgsReturnMap(map: customMap.map)
        )
        XCTAssertEqual(returnedMap, customMap.map)

        // returnCustomMap
//        let returnedCustomMap: CustomMap = try client.invoke(
//            uri: uri,
//            method: "returnCustomMap",
//            args: ArgsReturnCustomMap(foo: customMap)
//        )
//        XCTAssertEqual(returnedCustomMap, createCustomMap())

        // returnNestedMap
//        var nestedMap: [String: [String: UInt32]] = [:]
//        nestedMap["Hello"] = ["Nested Hello": 59]
//        nestedMap["Bye"] = ["Nested Bye": 60]
//        let returnedNestedMap: [String: [String: UInt32]] = try client.invoke(
//            uri: uri,
//            method: "returnNestedMap",
//            args: ArgsReturnNestedMap(foo: nestedMap)
//        )
//        XCTAssertEqual(returnedNestedMap, nestedMap)
    }
}
