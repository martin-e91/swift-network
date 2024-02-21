import Foundation
import NetworkAPI

struct NetworkRequestAdapterImpl: NetworkRequestAdapter {

    // MARK: - Methods

    func urlRequest(for request: any NetworkRequest) throws -> URLRequest {
        guard let url = try request.endpoint.urlComponents.url else {
            throw NetworkError.invalidRequestURL
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        if let parameters = request.parameters {
            try add(parameters, to: &urlRequest)
        }
        return urlRequest
    }

    private func add(_ parameters: RequestParameter, to urlRequest: inout URLRequest) throws {
        switch parameters {
        case let .query(parameters):
            try add(parameters.asQueryItems, to: &urlRequest)
        }
    }

    private func add(_ queryItems: [URLQueryItem], to urlRequest: inout URLRequest) throws {
        guard
            let url = urlRequest.url,
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            throw NetworkError.invalidRequestURL
        }
        components.queryItems = queryItems
        urlRequest.url = components.url
    }
}

// MARK: - Helpers

private extension Dictionary<String, Any> {
    var asQueryItems: [URLQueryItem] {
        map { (key, value) in
            URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        }
    }
}
