//
//  Msgpack.swift
//  
//
//  Created by Cesar Brazon on 12/6/23.
//

import Foundation
import MessagePacker

public func encode<T: Codable>(value: T) throws -> [UInt8] {
    let data = try! MessagePackEncoder().encode(value)
    return [UInt8](data)
}

public func decode<T: Codable>(value: [UInt8]) throws -> T {
    return try! MessagePackDecoder().decode(T.self, from: Data(value))
}

