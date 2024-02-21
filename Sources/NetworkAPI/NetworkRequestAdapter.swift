import Foundation

/// An adapter of ``NetworkRequest`` to ``URLRequest``.
public protocol NetworkRequestAdapter {
    /// Returns the `URLRequest` associated to the given ``NetworkRequest``.
    /// - Parameter request: The request to map.
    /// - Returns: The `URLRequest` associated to the given ``NetworkRequest``.
    /// - Throws: ``NetworkError``.
    func urlRequest(for request: any NetworkRequest) throws -> URLRequest
}
