import NetworkAPI
import XCTest

@testable import Network

final class StandardRequestParametersEncoderTests: XCTestCase {
	private var sut: StandardRequestParametersEncoder!

	override func setUp() {
		super.setUp()
		sut = StandardRequestParametersEncoder()
	}

	override func tearDown() {
		sut = nil
		super.tearDown()
	}

	func testEncode_whenCalledWithQueryParameters_shouldEncodeQueryItemsInURLRequest() throws {
		// Given
		var urlRequest = try URLRequest(url: XCTUnwrap(URL(string: "google.com")))

		// When
		try sut.encode(parameters: .query(["size": "90", "color": "red"]), in: &urlRequest)

		// Then
		let encodedQueryItems = try XCTUnwrap(urlRequest.url.flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: false)?.queryItems })
		let expectedQueryParams = [URLQueryItem(name: "size", value: "90"), URLQueryItem(name: "color", value: "red")]
		XCTAssertTrue(encodedQueryItems.allSatisfy(expectedQueryParams.contains(_:)))
	}

	func testEncode_whenCalledWithBodyParameter_shouldEncodeHTTPBodyInURLRequest() {
		// Given

		// When

		// Then
		XCTFail("Not Implemented")
	}
}
