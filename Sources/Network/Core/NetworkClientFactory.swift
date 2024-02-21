import Foundation
import NetworkAPI

public struct NetworkClientFactoryImpl: NetworkClientFactory {
    public init() {}

    public func networkClient(with session: URLSessionProtocol) -> NetworkClient {
        NetworkClientImpl(session: session, requestAdapter: NetworkRequestAdapterImpl())
    }
}
