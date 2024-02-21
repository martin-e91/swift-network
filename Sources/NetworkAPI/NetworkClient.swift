/// A client that can perform network requests.
public protocol NetworkClient {
    /// Performs the given network request, returning the decoded response model.
    /// - Parameter request: The request to execute.
    /// - Returns: The response model upon success, throws an error elsewhere.
    /// - Throws: ``NetworkError``.
    func perform<Request: NetworkRequest>(_ request: Request) async throws -> Request.Response
}
