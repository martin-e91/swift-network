import Foundation
import NetworkAPI

public struct NetworkClientImpl: NetworkClient {
    let session: URLSessionProtocol
    let requestAdapter: NetworkRequestAdapter

    package init(session: URLSessionProtocol, requestAdapter: NetworkRequestAdapter) {
        self.session = session
        self.requestAdapter = requestAdapter
    }

    public func perform<Request>(_ request: Request) async throws -> Request.Response where Request : NetworkRequest {
        let urlRequest = try requestAdapter.urlRequest(for: request)
        let (data, _) = try await session.data(for: urlRequest)
        return try JSONDecoder().decode(Request.Response.self, from: data)
    }
}
