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
    if let dictionary = value as? [String: AnyEncodable] {
        do {
            // If the value is a dictionary, treat it as a custom extension type
            let data = try JSONSerialization.data(withJSONObject: dictionary)  // Convert the dictionary to Data
            let extensionValue = MessagePackExtension(type: 0x1, data: data)
            let encodedData = try encoder.encode(extensionValue)
            return [UInt8](encodedData)
        } catch {
            throw EncodingError.invalidValue(value, EncodingError.Context(
                codingPath: [],
                debugDescription: "Failed to encode dictionary as MessagePack extension type",
                underlyingError: error
            ))
        }
    } else {
        // Otherwise, treat it as a normal Encodable value
        let data = try encoder.encode(AnyEncodable(value))
        return [UInt8](data)
    }
}

public func decode<T: Decodable>(value: [UInt8]) throws -> T {
    let decoder = MessagePackDecoder()
    do {
        return try decoder.decode(T.self, from: Data(value))
    } catch {
        do {
            let extensionValue = try decoder.decode(MessagePackExtension.self, from: Data(value))
            // If the extension type is 0x1, decode the value since we know it's a dictionary
            if extensionValue.type == 1 {
                return try decoder.decode(T.self, from: extensionValue.data)
            }
        } catch {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Failed to decode map extension type",
                    underlyingError: error
                )
            )
        }
    }
    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Failed to decode value"))
}
