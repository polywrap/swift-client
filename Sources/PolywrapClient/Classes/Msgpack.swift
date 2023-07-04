//
//  Msgpack.swift
//  
//
//  Created by Cesar Brazon on 12/6/23.
//

import Foundation
import MessagePacker

public struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void

    public init<EncodableType: Encodable>(_ value: EncodableType) {
        _encode = value.encode
    }

    public func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}

public func encode<T: Encodable>(value: T) throws -> [UInt8] {
    let encoder = MessagePackEncoder()
    let data = try encoder.encode(AnyEncodable(value))
    return [UInt8](data)
}

public func decode<T: Decodable>(value: [UInt8]) throws -> T {
    let decoder = MessagePackDecoder()
    return try decoder.decode(T.self, from: Data(value))
}
