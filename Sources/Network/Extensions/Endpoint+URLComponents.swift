import Foundation
import NetworkAPI

enum EndpointError: Error {
    case invalidScheme
}

public extension Endpoint {
    /// The `URLComponents` instance built from this endpoint.
    var urlComponents: URLComponents {
        get throws {
            guard let normalisedScheme = scheme.removingPercentEncoding, !normalisedScheme.isEmpty else {
                throw EndpointError.invalidScheme
            }

            var components = URLComponents()
            components.scheme = scheme
            components.host = host

            if !path.isEmpty {
                components.path = "/" + path.joined(separator: "/")
            }

            return components
        }
    }
}
