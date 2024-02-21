import NetworkAPI

public final class NetworkRequestMock<ResponseType>: NetworkRequest where ResponseType: Decodable {
    public typealias Response = ResponseType

    public var method: HTTPMethod
    
    public var endpoint: Endpoint
    
    public var parameters: RequestParameter?

    public var responseMock: ResponseType

    public init(method: HTTPMethod, endpoint: Endpoint, parameters: RequestParameter?, responseMock: Response) {
        self.method = method
        self.endpoint = endpoint
        self.parameters = parameters
        self.responseMock = responseMock
    }
}
