import Foundation

public struct NetworkRequestImpl<Response: Decodable>: NetworkRequest {
    public let method: HTTPMethod
    public let endpoint: Endpoint
    public let parameters: RequestParameter?

    public init(method: HTTPMethod, endpoint: Endpoint, parameters: RequestParameter?) {
        self.method = method
        self.endpoint = endpoint
        self.parameters = parameters
    }
}
