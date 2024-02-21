import NetworkAPI
import NetworkMocks
import XCTest

@testable import Network

final class Endpoint_URLComponentsTests: XCTestCase {
    // MARK: - urlComponents

    func testURLComponents_whenCalledOnEndpointNonEmptyParameters_shallReturnExpectedResults() throws {
        // Given
        let sut = EndpointMock(scheme: "myScheme", host: "myHost", path: ["some", "path"])

        // When
        let result = try sut.urlComponents

        // Then
        XCTAssertEqual(result.host, "myHost")
        XCTAssertEqual(result.scheme, "myScheme")
        XCTAssertEqual(result.path, "/some/path")
    }

    func testURLComponents_whenCalledOnEndpointWithEmptySchemeParameters_shallThrowEndpointError() throws {
        // Given
        let sut = EndpointMock(scheme: "", host: "", path: [])

        // When
        do {
            _ = try sut.urlComponents
            XCTFail("Previous call should throw error.")
        } catch let error as EndpointError {
            // Then
            XCTAssertEqual(error, .invalidScheme)
        } catch {
            XCTFail("expected EndpointError instead.")
        }
    }

    func testURLComponents_whenCalledOnEndpointWithEmptyHostParameters_shallReturnExpectedResults() throws {
        // Given
        let sut = EndpointMock(scheme: "non-empty", host: "", path: [])

        // When
        let result = try sut.urlComponents

        // Then
        XCTAssertEqual(result.scheme, "non-empty")
        XCTAssertEqual(result.host, "")
        XCTAssertEqual(result.path, "")
    }
}
