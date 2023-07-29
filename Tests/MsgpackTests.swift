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
        let customStruct: [String: CustomStruct] = ["one": CustomStruct(1)]
        guard let encoded = try? encode(value: customStruct),
              let decoded: [String: CustomStruct] = try? decode(value: encoded)
        else {
            XCTFail("Encoding failed")
            return
        }
        XCTAssertEqual(decoded, customStruct)
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
