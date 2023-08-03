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

/// Encodes an `Encodable` type into a msgpack buffer.
///
/// - Parameter value: An `Encodable` type value.
/// - Throws: If the encoding process fails.
/// - Returns: A msgpack buffer representing the encoded value
public func encode<T: Encodable>(value: T) throws -> [UInt8] {
    let encoder = MessagePackEncoder()
    let data = try encoder.encode(value)
    return [UInt8](data)
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
        throw DecodingError.dataCorrupted(
            DecodingError.Context(
                codingPath: [],
                debugDescription: "Failed to decode value"
            )
        )
    }
}



public struct Map<Key: Codable & Hashable, Value: Codable & Equatable>: Codable, Equatable {
    public static func == (lhs: Map<Key, Value>, rhs: Map<Key, Value>) -> Bool {
        lhs.dictionary == rhs.dictionary
    }

    var dictionary: [Key: Value]

    public init(_ dictionary: [Key: Value]) {
        self.dictionary = dictionary
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let encoder = MessagePackEncoder()
        do {
            let dicData = try encoder.encode(self.dictionary)
            let extensionValue = MessagePackExtension(type: 1, data: dicData)
            try container.encode(extensionValue)
        } catch {
            throw EncodingError.invalidValue(
                dictionary,
                EncodingError.Context(
                    codingPath: [],
                    debugDescription: "Failed to encode dictionary as MessagePack extension type",
                    underlyingError: error
                )
            )
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let decoder = MessagePackDecoder()
        do {
            let extensionValue = try container.decode(MessagePackExtension.self)
            if extensionValue.type == 1 {
                dictionary = try decoder.decode([Key: Value].self, from: extensionValue.data)
            } else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: [],
                        debugDescription: "Unexpected extension type"
                    )
                )
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
}
