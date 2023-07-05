//
//  Plugin.swift
//  
//
//  Created by Cesar Brazon on 21/6/23.
//

import Foundation

public struct AddArgs: Codable {
    var a: Int
    var b: Int
    
    public init(a: Int, b: Int) {
        self.a = a
        self.b = b
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

class MemoryStoragePlugin: PluginModule {
    private var value: Int

    public override init() {
        self.value = 0
        super.init()
    }

    public func getData(_: [String: Any]) async throws -> Int {
        try await sleep(ms: 50)
        return self.value
    }

    public func setData(args: [String: Int]) async throws -> Bool {
        try await sleep(ms: 50)
        guard let val = args["value"] else {
            return false
        }
        self.value = val
        return true
    }

    public func sleep(ms: Int) async throws {
        let duration = DispatchTimeInterval.milliseconds(ms)
        let deadline = DispatchTime.now().advanced(by: duration)
        try await Task.sleep(nanoseconds: UInt64(deadline.uptimeNanoseconds))
    }
}


