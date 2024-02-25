import Foundation
import NetworkAPI

/// A ``NetworkRequestAdapter`` with default behaviour.
struct StandardNetworkRequestAdapter: NetworkRequestAdapter {
	let parametersEncoder: ParametersEncoder

    // MARK: - Methods

    func urlRequest(for request: any NetworkRequest) throws -> URLRequest {
        guard let url = try request.endpoint.urlComponents.url else {
            throw NetworkError.invalidRequestURL
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
		if let parameters = request.parameters {
			try parametersEncoder.encode(parameters: parameters, in: &urlRequest)
		}
        return urlRequest
    }
}
