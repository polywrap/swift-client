import XCTest
import PolywrapClient


final class PolywrapClientTests: XCTestCase {
    func testUri() throws {
        let uri = Uri("wrap/mock")
        let stringUri = uri?.ffiUri.toStringUri()
        XCTAssertEqual(stringUri, "wrap://wrap/mock")
    }
}

