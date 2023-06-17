import XCTest
import PolywrapClient


final class UriTests: XCTestCase {
    func create_uri() throws {
        let uri = Uri("wrap/mock")
        let stringUri = uri?.ffiUri.toStringUri()
        XCTAssertEqual(stringUri, "wrap://wrap/mock")
    }
}

