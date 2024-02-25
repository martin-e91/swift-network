import Foundation
import NetworkAPI

public struct NetworkClientFactoryImpl: NetworkClientFactory {
    public init() {}

    public func networkClient(with session: URLSessionProtocol) -> NetworkClient {
		let adapter = StandardNetworkRequestAdapter(parametersEncoder: StandardRequestParametersEncoder())
        return NetworkClientImpl(session: session, requestAdapter: adapter)
    }
}
