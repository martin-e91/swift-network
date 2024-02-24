import NetworkMocks
import XCTest

@testable import Network

final class NetworkRequestAdapterImplTests: XCTestCase {
    private var sut: NetworkRequestAdapterImpl!

    override func setUp() {
        super.setUp()
        sut = .init()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - urlRequest

    func testURLRequest_whenEndpointHasValidURLComponents_shallReturnExpectedInstance() throws {
        // Given
        let validEndpoint = EndpointMock(scheme: "http", host: "google.com", path: ["hola", "barcelona"])
        let request = NetworkRequestMock(method: .get, endpoint: validEndpoint, parameters: nil, responseMock: "")

        // When
        let result = try XCTUnwrap(sut.urlRequest(for: request))

        // Then
        XCTAssertEqual(result.httpMethod, "GET")
        XCTAssertNil(result.httpBody)
		let resultURLComponents = try XCTUnwrap(result.url.flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: false) })
		XCTAssertEqual(resultURLComponents.scheme, "http")
		XCTAssertEqual(resultURLComponents.host, "google.com")
		XCTAssertEqual(resultURLComponents.path, "/hola/barcelona")
		XCTAssertNil(resultURLComponents.query)
    }

    func testURLRequest_whenEndpointHasInvalidScheme_shallThrowInvalidSchemeEndpointError() throws {
        // Given
        let invalidScheme = ""
        let endpointWithInvalidScheme = EndpointMock(scheme: invalidScheme)
        let request = NetworkRequestMock(method: .get, endpoint: endpointWithInvalidScheme, parameters: nil, responseMock: "")

        // When
        do {
            _ = try sut.urlRequest(for: request)
            XCTFail("Previous call should throw error instead.")
        } catch {
            let error = try XCTUnwrap(error as? EndpointError)
            XCTAssertEqual(error, .invalidScheme)
        }
    }

    func testURLRequest_whenRequestHasQueryParameters_shallReturnURLRequestWithURLContainingQueryParameters() throws {
        // Given
        let validEndpoint = EndpointMock(scheme: "https", host: "good-beers.com", path: ["api", "v2"])
        let request = NetworkRequestMock(method: .get, endpoint: validEndpoint, parameters: .query(["type": "IPA", "page": 5]), responseMock: 9)

        // When
        let result = try XCTUnwrap(sut.urlRequest(for: request))

        // Then
        XCTAssertEqual(result.httpMethod, "GET")
		XCTAssertNil(result.httpBody)
		let resultURLComponents = try XCTUnwrap(result.url.flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: false) })
		XCTAssertEqual(resultURLComponents.scheme, "https")
		XCTAssertEqual(resultURLComponents.host, "good-beers.com")
		XCTAssertEqual(resultURLComponents.path, "/api/v2")
		let expectedQueryItems = [URLQueryItem(name: "type", value: "IPA"), URLQueryItem(name: "page", value: "5")]
		let resultQueryItems = try XCTUnwrap(resultURLComponents.queryItems)
		XCTAssertEqual(resultQueryItems.count, expectedQueryItems.count)
		XCTAssertTrue(expectedQueryItems.allSatisfy { resultQueryItems.contains($0) })
    }
}
