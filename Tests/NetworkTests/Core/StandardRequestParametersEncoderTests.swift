import NetworkAPI
import XCTest

@testable import Network

final class StandardRequestParametersEncoderTests: XCTestCase {
	private var bodyEncoder: JSONEncoder!
	private var sut: StandardRequestParametersEncoder!

	override func setUp() {
		super.setUp()
		bodyEncoder = JSONEncoder()
		bodyEncoder.outputFormatting = .sortedKeys // formatting the output will allow us to avoid boilerplate while asserting on expected body.
		sut = StandardRequestParametersEncoder(bodyEncoder: bodyEncoder)
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

	func testEncode_whenCalledWithBodyParameter_shouldEncodeHTTPBodyInURLRequest() throws {
		// Given
		var urlRequest = try URLRequest(url: XCTUnwrap(URL(string: "google.com")))

		// When
		try sut.encode(parameters: .body("hello, world!"), in: &urlRequest)

		// Then
		let resultHTTPBody = try XCTUnwrap(urlRequest.httpBody)
		let expectedBody = try bodyEncoder.encode("hello, world!")
		XCTAssertEqual(resultHTTPBody, expectedBody)
	}

	func testEncode_whenCalledWithBodyWithCustomType_shouldEncodeHTTPBodyInURLRequest() throws {
		// Given
		struct Beer: Encodable {
			let name: String
			let alchool: Int
		}

		var urlRequest = try URLRequest(url: XCTUnwrap(URL(string: "google.com")))

		// When
		try sut.encode(parameters: .body(Beer(name: "Leffe", alchool: 7)), in: &urlRequest)

		// Then
		let resultHTTPBody = try XCTUnwrap(urlRequest.httpBody)
		let expectedBody = try bodyEncoder.encode(Beer(name: "Leffe", alchool: 7))
		XCTAssertEqual(resultHTTPBody, expectedBody)
	}

	func testEncode_whenCalledWithBodyWithArrayType_shouldEncodeHTTPBodyInURLRequest() throws {
		// Given
		struct Beer: Encodable {
			let name: String
			let alchool: Int
		}

		var urlRequest = try URLRequest(url: XCTUnwrap(URL(string: "google.com")))

		// When
		try sut.encode(parameters: .body([Beer(name: "Leffe", alchool: 7), Beer(name: "Estrella Galicia", alchool: 3)]), in: &urlRequest)

		// Then
		let resultHTTPBody = try XCTUnwrap(urlRequest.httpBody)
		let expectedBody = try bodyEncoder.encode([Beer(name: "Leffe", alchool: 7), Beer(name: "Estrella Galicia", alchool: 3)])
		XCTAssertEqual(resultHTTPBody, expectedBody)
	}
}
