import Foundation
import NetworkAPI

struct StandardRequestParametersEncoder: ParametersEncoder {
	func encode(parameters: RequestParameter, in request: inout URLRequest) throws {
		switch parameters {
		case let .query(dictionary):
			guard let queryItems = dictionary.asQueryItems else { return }
			try add(queryItems, to: &request)

		case let .body(encodale):
			return
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

private extension Dictionary where Key == String {
	var asQueryItems: [URLQueryItem]? {
		map { (key, value) in
			URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
		}
	}
}
