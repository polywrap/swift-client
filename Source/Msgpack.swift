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

struct AnyEncodableDictionary: Encodable {
    let dictionary: [String: AnyEncodable]
}

/// Encodes an `Encodable` type into a msgpack buffer.
///
/// - Parameter value: An `Encodable` type value.
/// - Throws: If the encoding process fails.
/// - Returns: A msgpack buffer representing the encoded value
public func encode<T: Encodable>(value: T) throws -> [UInt8] {
    let encoder = MessagePackEncoder()
    if let dictionary = value as? [String: Encodable] {
        let anyEncodableDictionary = dictionary.mapValues { AnyEncodable($0) }
        do {
            let dicData = try encoder.encode(anyEncodableDictionary)
            let extensionValue = MessagePackExtension(type: 0x1, data: dicData)
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

/// Decodes a msgpack buffer into a `Decodable` type.
///
/// - Parameter value: A msgpack buffer to be decoded.
/// - Throws: If the decoding process fails.
/// - Returns: A value of `Decodable` type derived from the msgpack buffer.
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
