//
//  Plugin.swift
//  
//
//  Created by Cesar Brazon on 21/6/23.
//

import Foundation
import PolywrapClient

public struct AddArgs: Codable {
    var a: Int
    var b: Int
    
    public init(a: Int, b: Int) {
        self.a = a
        self.b = b
    }
}

public struct SetDataArgs: Codable {
    public var value: Int
    public init(_ value: Int) {
        self.value = value
    }
}

public struct EmptyArgs: Codable {}
public struct EmptyEnv: Codable {}
public struct PlusOneArgs: Codable {}

public class MockPlugin: PluginModule {
    public var counter = 0
    public init(_ value: Int?) {
        if value != nil {
            self.counter = value!
        }
    }
    
    public func add(_ args: AddArgs, _ env: EmptyEnv?, _ invoker: Invoker) -> Int {
        return args.a + args.b
    }
    
    public func increment(_ args: EmptyArgs, _ env: EmptyEnv?, _ invoker: Invoker) throws {
        self.counter += 1
    }
}

public class MemoryStoragePlugin: PluginModule {
    private var value: Int

    public override init() {
        self.value = 0
    }

    public func getData(_: EmptyArgs, _: EmptyEnv?, _: Invoker) async throws -> Int {
        try await Task.sleep(nanoseconds: UInt64(50 * 1_000_000))
        return self.value
    }

    public func setData(args: SetDataArgs, _: EmptyEnv?, _: Invoker) async throws -> Bool {
        try await Task.sleep(nanoseconds: UInt64(50 * 1_000_000))
        self.value = args.value
        return true
    }

    func sleep(ms: Int) async throws {
        try await Task.sleep(nanoseconds: UInt64(ms))
    }
}


