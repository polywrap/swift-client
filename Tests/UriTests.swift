import XCTest
import PolywrapClient


final class UriTests: XCTestCase {
    func create_uri() throws {
        let uri = try! Uri("wrap/mock")
        let stringUri = uri.ffi.toStringUri()
        XCTAssertEqual(stringUri, "wrap://wrap/mock")
    }
}

