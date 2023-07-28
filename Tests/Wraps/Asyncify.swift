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

final class AsyncifyTest: XCTestCase {
    func testSubsequentInvokes() throws {
        let reader = ResourceReader(bundle: Bundle.module)

        let bytes = try reader.readFile("Cases/asyncify/implementations/rs")
        let embedded_wrapper = try WasmWrapper(module: bytes)
        let uri = try Uri("wrap://wrap/embedded")
        
        var storagePlugin = MemoryStoragePlugin()
        storagePlugin.addMethod(name: "getData", closure: storagePlugin.getData)
        storagePlugin.addMethod(name: "setData", closure: storagePlugin.setData)
        let wrapPackage = PluginPackage(storagePlugin)

        let storageUri = try Uri("wrap://ens/memory-storage.polywrap.eth")
        let builder = BuilderConfig().addWrapper(uri, embedded_wrapper).addPackage(storageUri, wrapPackage)
        
        let client = builder.build()
        let result: [String] = try client.invoke(uri: uri, method: "subsequentInvokes", args: ArgsSubsequentInvokes(40), env: nil)
        let expected = Array(0..<40).map { String($0) }
        XCTAssertEqual(result, expected)
    }
}

