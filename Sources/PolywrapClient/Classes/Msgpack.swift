//
//  Msgpack.swift
//  
//
//  Created by Cesar Brazon on 12/6/23.
//

import Foundation
import MessagePacker

public func encode<T: Encodable>(value: T) throws -> [UInt8] {
    let encoder = MessagePackEncoder()
    
    let data = try! MessagePackEncoder().encode(value)
    return [UInt8](data)
}

public func decode<T: Decodable>(value: [UInt8]) throws -> T {
    return try! MessagePackDecoder().decode(T.self, from: Data(value))
}

