import XCTest
import Foundation

@testable import PolywrapClient

struct CustomStruct: Encodable, Equatable, Decodable {
    public var int: Int
    public init(_ int: Int) {
        self.int = int
    }
}

class MsgpackTests: XCTestCase {
    func testEncodeMapWithStruct() {
        let customStruct: Map<String, CustomStruct> = Map(["one": CustomStruct(1)])
        do {
            let encoded = try encode(value: customStruct)
            print(encoded)
            let decoded: Map<String, CustomStruct> = try decode(value: encoded)
            print(decoded)
        } catch {
            print(error)
        }
//        guard let encoded = try? encode(value: customStruct),
//              let decoded: Map<String, CustomStruct> = try? decode(value: encoded)
//        else {
//            XCTFail("Encoding failed")
//            return
//        }
//        XCTAssertEqual(decoded, customStruct)
    }

    func testEncodeDecodeMap() {
        var customMap: [String: String] = [:]
        customMap["firstKey"] = "firstValue"
        customMap["secondKey"] = "secondValue"

        guard let encoded = try? encode(value: customMap),
              let decoded: [String: String] = try? decode(value: encoded)
        else {
            XCTFail("Encoding or decoding failed")
            return
        }

        XCTAssertEqual(decoded, customMap)
    }

    func testEncodeDecodeNestedMap() {
        var customMap: [String: [String: String]] = [:]
        customMap["firstKey"] = ["one": "1"]
        customMap["secondKey"] = ["second": "2"]

        guard let encoded = try? encode(value: customMap),
              let decoded: [String: [String: String]] = try? decode(value: encoded)
        else {
            XCTFail("Encoding or decoding failed")
            return
        }

        XCTAssertEqual(decoded, customMap)
    }

    func testEncodeDecodeComplexStructWithNestedMap() throws {
        struct ComplexStruct: Codable, Equatable {
            let map: [String: Int]
            let nestedMap: [String: [String: Int]]
        }
        
        let map = ["Hello": 1, "Heyo": 50]
        let nestedMap = ["nested": map]
        
        let complexStruct = ComplexStruct(map: map, nestedMap: nestedMap)
        let encoded = try encode(value: complexStruct)
        XCTAssertEqual(encoded, [130, 163, 109, 97, 112, 199, 14, 1, 130, 165, 72, 101, 108, 108, 111, 1, 164, 72, 101, 121, 111, 50, 169, 110, 101, 115, 116, 101, 100, 77, 97, 112, 199, 25, 1, 129, 166, 78, 101, 115, 116, 101, 100, 199, 14, 1, 130, 165, 72, 101, 108, 108, 111, 1, 164, 72, 101, 121, 111, 50])
    }

    func testEncodeDecodeMapOfBytes() {
        var customMap: [String: [UInt8]] = [:]
        customMap["firstKey"] = [1, 2, 3]
        customMap["secondKey"] = [3, 2, 1]

        guard let encoded = try? encode(value: customMap),
              let decoded: [String: [UInt8]] = try? decode(value: encoded)
        else {
            XCTFail("Encoding or decoding failed")
            return
        }

        XCTAssertEqual(decoded, customMap)
    }
    
    func testEncodeDecodeString() {
        guard let encoded = try? encode(value: "foo"),
              let decoded: String = try? decode(value: encoded)
        else {
            XCTFail("Encoding or decoding failed")
            return
        }
        
        XCTAssertEqual(decoded, "foo")
    }
}
