import NetworkAPI

public final class EndpointMock: Endpoint {
    public var scheme: String
    public var host: String
    public var path: PathComponents

    public init(scheme: String = "", host: String = "", path: PathComponents = []) {
        self.scheme = scheme
        self.host = host
        self.path = path
    }
}
