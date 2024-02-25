import Foundation

public protocol NetworkRequest {
    associatedtype Response: Decodable

    var method: HTTPMethod { get }
    var endpoint: Endpoint { get }
    var parameters: RequestParameter? { get }
}

// MARK: - Default Implementation

public extension NetworkRequest {
	var parameters: RequestParameter? { nil }
}
