import XCTest
import Foundation

@testable import PolywrapClient

class UriTests: XCTestCase {
    func testUriFromString() {
        let testUri = "mock/uri"
        do {
            let uri = try Uri(testUri)
            XCTAssertNotNil(uri)
        } catch {
            XCTFail("Failed to create Uri")
        }
    }

    func testUriFromParameters() {
        let authority = "example.com"
        let path = "/test"
        let uri = Uri(authority, path, uri: "https://example.com/test")
        XCTAssertNotNil(uri)
    }

    func testInvalidUri() {
        let invalidUri = "invalid uri"
        do {
            _ = try Uri(invalidUri)
            XCTFail("Expected an error when creating Uri from invalid string, but did not get one")
        } catch let error as UriError {
            XCTAssertEqual(error, UriError.parseError("Invalid URI Received: \(invalidUri)"))
        } catch {
            XCTFail("Expected UriError, but got: \(error)")
        }
    }
}
