import NetworkMocks
import XCTest

@testable import Network

final class NetworkClientImplTests: XCTestCase {
    private var requestAdapterMock: NetworkRequestAdapterMock!
    private var sessionMock: URLSessionProtocolMock!
    private var sut: NetworkClientImpl!

    override func setUp() {
        super.setUp()
        requestAdapterMock = .init()
        sessionMock = .init()
        sut = .init(session: sessionMock, requestAdapter: requestAdapterMock)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - perform

    func testPerform_whenDecodingSucceeds_shallReturnResponseType() async throws {
        struct MyResponse: Codable, Equatable {
            let value: String
        }

        // Given
        let expectedResponse = MyResponse(value: "hello, world!")
        let request = NetworkRequestMock(method: .get, endpoint: EndpointMock(scheme: "fff", host: "lol", path: []), parameters: nil, responseMock: expectedResponse)
        let mockURLRequest = URLRequest(url: URL(string: "www.mockurl.com")!)
        requestAdapterMock.urlRequestResult = .success(mockURLRequest)
        let expectedData = try JSONEncoder().encode(expectedResponse)
        let expectedURLResponse = URLResponse()
        sessionMock.dataResult = .success((expectedData, expectedURLResponse))

        // When
        let response = try await sut.perform(request)

        // Then
        XCTAssertEqual(response, expectedResponse)
    }

    func testPerform_whenURLRequestCreationFails_shallThrowErrorFromAdapter() async throws {
        // Given
        let expectedError = NSError(domain: #function, code: 99)
        requestAdapterMock.urlRequestResult = .failure(expectedError)
        let request = NetworkRequestMock(method: .get, endpoint: EndpointMock(scheme: "fff", host: "lol", path: []), parameters: nil, responseMock: 7)

        // When
        do {
            _ = try await sut.perform(request)
            XCTFail("previous call should throw error")
        } catch {
            // Then
            XCTAssertEqual(error as NSError, expectedError)
        }
    }

    func testPerform_whenSessionDataCallFails_shallThrowFromURLSession() async throws {
        // Given
        let expectedError = NSError(domain: #function, code: 99)
        sessionMock.dataResult = .failure(expectedError)
        requestAdapterMock.urlRequestResult = .success(.init(url: .init(string: "www.google.com")!))
        let request = NetworkRequestMock(method: .get, endpoint: EndpointMock(scheme: "fff", host: "lol", path: []), parameters: nil, responseMock: 7)

        // When
        do {
            _ = try await sut.perform(request)
            XCTFail("previous call should throw error")
        } catch {
            // Then
            XCTAssertEqual(error as NSError, expectedError)
        }
    }

    func testPerform_whenDecodingFails_shallThrowDecodingError() async throws {
        // Given
        let expectedResponse = "successful response"
        let request = NetworkRequestMock(method: .get, endpoint: EndpointMock(scheme: "fff", host: "lol", path: []), parameters: nil, responseMock: expectedResponse)
        let mockURLRequest = URLRequest(url: URL(string: "www.mockurl.com")!)
        requestAdapterMock.urlRequestResult = .success(mockURLRequest)
        let expectedData = expectedResponse.data(using: .utf8)!
        let expectedURLResponse = URLResponse()
        sessionMock.dataResult = .success((expectedData, expectedURLResponse))

        // When
        do {
            _ = try await sut.perform(request)
            XCTFail("previous call should throw error")
        } catch let error as DecodingError {
            switch error {
            case let .dataCorrupted(context):
                XCTAssertEqual(context.debugDescription, "The given data was not valid JSON.")
                XCTAssertTrue(context.codingPath.isEmpty)
            default:
                XCTFail("unexpected error was thrown")
            }
        } catch {
            XCTFail("unexpected error type")
        }
    }
}
