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
        
        guard let encoded = try? encode(value: customStruct),
              let decoded: Map<String, CustomStruct> = try? decode(value: encoded)
        else {
            XCTFail("Encoding failed")
            return
        }
        XCTAssertEqual(decoded, customStruct)
    }

    func testEncodeDecodeMap() {
        var customMap: Map<String, String> = Map([:])
        customMap.dictionary["firstKey"] = "firstValue"
        customMap.dictionary["secondKey"] = "secondValue"

        guard let encoded = try? encode(value: customMap),
              let decoded: Map<String, String> = try? decode(value: encoded)
        else {
            XCTFail("Encoding or decoding failed")
            return
        }

        XCTAssertEqual(decoded, customMap)
    }

    func testEncodeDecodeNestedMap() {
        var customMap: Map<String, Map<String, String>> = Map([:])
        customMap.dictionary["firstKey"] = Map(["one": "1"])
        customMap.dictionary["secondKey"] = Map(["second": "2"])

        guard let encoded = try? encode(value: customMap),
              let decoded: Map<String, Map<String, String>> = try? decode(value: encoded)
        else {
            XCTFail("Encoding or decoding failed")
            return
        }

        XCTAssertEqual(decoded, customMap)
    }

    func testEncodeDecodeComplexStructWithNestedMap() throws {
        struct ComplexStruct: Codable, Equatable {
            let map: Map<String, Int>
            let nestedMap: Map<String, Map<String, Int>>
        }
        
        let map = Map(["Hello": 1, "Heyo": 50])
        let nestedMap = Map(["nested": map])
        
        let complexStruct = ComplexStruct(map: map, nestedMap: nestedMap)
        guard let encoded = try? encode(value: complexStruct),
              let decoded: ComplexStruct = try? decode(value: encoded)
        else {
            XCTFail("Encoding or decoding failed")
            return
        }
        XCTAssertEqual(decoded, complexStruct)

    }

    func testEncodeDecodeMapOfBytes() {
        var customMap: Map<String, [UInt8]> = Map([:])
        customMap.dictionary["firstKey"] = [1, 2, 3]
        customMap.dictionary["secondKey"] = [3, 2, 1]

        guard let encoded = try? encode(value: customMap),
              let decoded: Map<String, [UInt8]> = try? decode(value: encoded)
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
