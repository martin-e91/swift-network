import NetworkMocks
import XCTest

@testable import Network

final class NetworkRequestAdapterImplTests: XCTestCase {
	private var parametersEncoderMock: ParametersEncoderMock!
    private var sut: StandardNetworkRequestAdapter!

    override func setUp() {
        super.setUp()
		parametersEncoderMock = ParametersEncoderMock()
        sut = StandardNetworkRequestAdapter(parametersEncoder: parametersEncoderMock)
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
        let result = try sut.urlRequest(for: request)

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

	func testURLRequest_whenRequestHasNilParameters_shouldReturnURLRequestWithoutCallingParameterEncoder() throws {
		// Given
		let validEndpoint = EndpointMock(scheme: "https", host: "good-beers.com", path: ["api", "v2"])
		let request = NetworkRequestMock(method: .post, endpoint: validEndpoint, parameters: nil, responseMock: 9)

		// When
		let result = try sut.urlRequest(for: request)

		// Then
		XCTAssertEqual(result.httpMethod, "POST")
		XCTAssertEqual(parametersEncoderMock.encodeCallCount, .zero)
		XCTAssertNil(parametersEncoderMock.encodeError)
		XCTAssertNil(parametersEncoderMock.encodeParametersParameter)
	}

	func testURLRequest_whenCalledWithSomeParameters_shouldReturnUpdatedURLRequest() throws {
		// Given
		parametersEncoderMock.encodeRequestParameterUpdater = { urlRequest in
			urlRequest.httpMethod = "updated_method"
			urlRequest.timeoutInterval = 2
			urlRequest.httpBody = "updated_body".data(using: .utf8)
		}
		let validEndpoint = EndpointMock(scheme: "https", host: "good-beers.com", path: ["api", "v2"])
		let request = NetworkRequestMock(method: .put, endpoint: validEndpoint, parameters: .body("non_nil_parameter"), responseMock: 1)

		// When
		let result = try sut.urlRequest(for: request)

		// Then
		XCTAssertEqual(result.httpMethod, "updated_method")
		XCTAssertEqual(result.timeoutInterval, 2)
		let resultBody = try XCTUnwrap(result.httpBody)
		let expectedBody = try XCTUnwrap("updated_body".data(using: .utf8))
		XCTAssertEqual(resultBody, expectedBody)
		XCTAssertEqual(parametersEncoderMock.encodeCallCount, 1)
		guard case let .body(inputBody as String) = parametersEncoderMock.encodeParametersParameter else {
			XCTFail("`encode(parameters:request:)` was called with unexpected input.")
			return
		}
		XCTAssertEqual(inputBody, "non_nil_parameter")
		XCTAssertNil(parametersEncoderMock.encodeError)
	}

	func testURLRequest_whenParameterEncoderThrowsError_shouldThrowError() throws {
		// Given
		let expectedError = NSError(domain: #function, code: -1)
		parametersEncoderMock.encodeError = expectedError
		let validEndpoint = EndpointMock(scheme: "https", host: "good-beers.com", path: ["api", "v2"])
		let request = NetworkRequestMock(method: .post, endpoint: validEndpoint, parameters: .query(["par1": "hola"]), responseMock: 9)

		// When
		do {
			_ = try sut.urlRequest(for: request)
			XCTFail("Previous call should throw error instead.")
		} catch {
			// Then
			let error = error as NSError
			XCTAssertEqual(error, expectedError)
			XCTAssertEqual(parametersEncoderMock.encodeCallCount, 1)
			guard case let .query(inputParameter) = parametersEncoderMock.encodeParametersParameter else {
				XCTFail("`encode(parameters:request:)` was called with unexpected input.")
				return
			}
			XCTAssertEqual(inputParameter, ["par1": "hola"])
		}
	}
}
