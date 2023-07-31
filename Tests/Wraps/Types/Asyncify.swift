//
//  Asyncify.swift
//
//
//  Created by Cesar Brazon on 16/6/23.
//

import XCTest
import PolywrapClient

public struct ArgsSubsequentInvokes: Codable {
    public let numberOfTimes: Int
    public init(_ numberOfTimes: Int) {
        self.numberOfTimes = numberOfTimes
    }
}

public struct ArgsSetDataWithLargeArgs: Codable {
    public let value: String
}

public struct ArgsSetDataWithManyArgs: Codable {
    public let valueA: String
    public let valueB: String
    public let valueC: String
    public let valueD: String
    public let valueE: String
    public let valueF: String
    public let valueG: String
    public let valueH: String
    public let valueI: String
    public let valueJ: String
    public let valueK: String
    public let valueL: String
}

public struct BigObj: Codable {
    public let propA: String
    public let propB: String
    public let propC: String
    public let propD: String
    public let propE: String
    public let propF: String
    public let propG: String
    public let propH: String
    public let propI: String
    public let propJ: String
    public let propK: String
    public let propL: String
}

public struct ArgsSetDataWithManyStructuredArgs: Codable {
    public let valueA: BigObj
    public let valueB: BigObj
    public let valueC: BigObj
    public let valueD: BigObj
    public let valueE: BigObj
    public let valueF: BigObj
    public let valueG: BigObj
    public let valueH: BigObj
    public let valueI: BigObj
    public let valueJ: BigObj
    public let valueK: BigObj
    public let valueL: BigObj
}

func getClientWithAsyncify() throws -> (PolywrapClient, Uri) {
    var storagePlugin = MemoryStoragePlugin()
    storagePlugin.addMethod(name: "getData", closure: storagePlugin.getData)
    storagePlugin.addMethod(name: "setData", closure: storagePlugin.setData)
    let embeddedWrapper = try getTestWrap(path: "asyncify/implementations/rs")
    let wrapPackage = PluginPackage(storagePlugin)
    let storageUri = try Uri("wrap://plugin/memory-storage")
    let wrapUri = try Uri("wrap/asyncify")
    let builder = BuilderConfig()
        .addWrapper(wrapUri, embeddedWrapper)
        .addPackage(storageUri, wrapPackage)
    return (builder.build(), wrapUri)
}

final class AsyncifyTest: XCTestCase {
    func testSubsequentInvokes() throws {
        let (client, uri) = try getClientWithAsyncify()
        let result: [String] = try client.invoke(uri: uri, method: "subsequentInvokes", args: ArgsSubsequentInvokes(40))
        let expected = Array(0..<40).map { String($0) }
        XCTAssertEqual(result, expected)
    }
    
    func testLocalVarMethod() throws {
        let (client, uri) = try getClientWithAsyncify()
        let result: Bool = try client.invoke(uri: uri, method: "localVarMethod")
        XCTAssertTrue(result)
    }
    
    func testGlobalVarMethod() throws {
        let (client, uri) = try getClientWithAsyncify()
        let result: Bool = try client.invoke(uri: uri, method: "globalVarMethod")
        XCTAssertTrue(result)
    }

    func testSetDataWithLargeArgs() throws {
        let (client, uri) = try getClientWithAsyncify()
        let largeStr = String(repeating: "polywrap", count: 10000)
        let result: String = try client.invoke(uri: uri, method: "setDataWithLargeArgs", args: ArgsSetDataWithLargeArgs(value: largeStr))
        XCTAssertEqual(result, largeStr)
    }

    func testSetDataWithManyArgs() throws {
        let (client, uri) = try getClientWithAsyncify()
        let args = ArgsSetDataWithManyArgs(valueA: "polywrap a", valueB: "polywrap b", valueC: "polywrap c", valueD: "polywrap d", valueE: "polywrap e", valueF: "polywrap f", valueG: "polywrap g", valueH: "polywrap h", valueI: "polywrap i", valueJ: "polywrap j", valueK: "polywrap k", valueL: "polywrap l")
        let result: String = try client.invoke(uri: uri, method: "setDataWithManyArgs", args: args)
        let expected = "polywrap apolywrap bpolywrap cpolywrap dpolywrap epolywrap fpolywrap gpolywrap hpolywrap ipolywrap jpolywrap kpolywrap l"
        XCTAssertEqual(result, expected)
    }

    func testSetDataWithManyStructuredArgs() throws {
        func createObj(i: Int) -> BigObj {
            return BigObj(
                propA: "a-\(i)",
                propB: "b-\(i)",
                propC: "c-\(i)",
                propD: "d-\(i)",
                propE: "e-\(i)",
                propF: "f-\(i)",
                propG: "g-\(i)",
                propH: "h-\(i)",
                propI: "i-\(i)",
                propJ: "j-\(i)",
                propK: "k-\(i)",
                propL: "l-\(i)"
            )
        }

        let (client, uri) = try getClientWithAsyncify()
        let args = ArgsSetDataWithManyStructuredArgs(
            valueA: createObj(i: 1),
            valueB: createObj(i: 2),
            valueC: createObj(i: 3),
            valueD: createObj(i: 4),
            valueE: createObj(i: 5),
            valueF: createObj(i: 6),
            valueG: createObj(i: 7),
            valueH: createObj(i: 8),
            valueI: createObj(i: 9),
            valueJ: createObj(i: 10),
            valueK: createObj(i: 11),
            valueL: createObj(i: 12)
        )
        let result: Bool = try client.invoke(uri: uri, method: "setDataWithManyStructuredArgs", args: args)
        XCTAssertTrue(result)
    }
}

