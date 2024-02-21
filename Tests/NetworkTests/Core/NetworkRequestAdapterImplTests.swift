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
        let validEndpoint = EndpointMock(scheme: "https", host: "google.com", path: ["hola", "barcelona"])
        let request = NetworkRequestMock(method: .get, endpoint: validEndpoint, parameters: nil, responseMock: "")

        // When
        let result = try XCTUnwrap(sut.urlRequest(for: request))

        // Then
        XCTAssertEqual(result.httpMethod, "GET")
        let expectedURL = URL(string: "https://google.com/hola/barcelona")!
        XCTAssertEqual(result.url, expectedURL)
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
        let expectedURL = URL(string: "https://good-beers.com/api/v2?page=5&type=IPA")!
        XCTAssertEqual(result.url, expectedURL)
    }
}
