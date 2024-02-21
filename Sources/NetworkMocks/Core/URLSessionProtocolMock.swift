import Foundation
import NetworkAPI

public final class URLSessionProtocolMock: URLSessionProtocol {
    public init() {}

    public var dataResult: Result<(Data, URLResponse), Error> = .failure(ErrorMock.missingStub)
    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try dataResult.get()
    }
}
