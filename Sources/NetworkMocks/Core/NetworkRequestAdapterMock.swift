import Foundation
import NetworkAPI

public final class NetworkRequestAdapterMock: NetworkRequestAdapter {
    public init() {}

    public var urlRequestResult: Result<URLRequest, Error> = .failure(ErrorMock.missingStub)
    public func urlRequest(for request: any NetworkRequest) throws -> URLRequest {
        try urlRequestResult.get()
    }
}
