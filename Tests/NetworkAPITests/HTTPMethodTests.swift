import NetworkAPI
import XCTest

final class HTTPMethodTests: XCTestCase {
	func testRawValue_whenCalled_shouldReturnExpectedValue() {
		XCTAssertEqual(HTTPMethod.get.rawValue, "GET")
		XCTAssertEqual(HTTPMethod.head.rawValue, "HEAD")
		XCTAssertEqual(HTTPMethod.post.rawValue, "POST")
		XCTAssertEqual(HTTPMethod.put.rawValue, "PUT")
		XCTAssertEqual(HTTPMethod.delete.rawValue, "DELETE")
		XCTAssertEqual(HTTPMethod.connect.rawValue, "CONNECT")
		XCTAssertEqual(HTTPMethod.options.rawValue, "OPTIONS")
		XCTAssertEqual(HTTPMethod.trace.rawValue, "TRACE")
	}
}
