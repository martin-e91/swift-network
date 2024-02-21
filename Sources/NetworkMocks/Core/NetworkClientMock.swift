import NetworkAPI

fileprivate enum NetworkClientMockError: Swift.Error {
    case stubTypeMismatch
}

public final class NetworkClientMock: NetworkClient {
    public init() {}

    public var performResult: Result<any Decodable, Error> = .failure(ErrorMock.missingStub)
    public func perform<Request: NetworkRequest>(_ request: Request) async throws -> Request.Response {
        guard let stub = try performResult.get() as? Request.Response else {
            throw NetworkClientMockError.stubTypeMismatch
        }
        return stub
    }
}
