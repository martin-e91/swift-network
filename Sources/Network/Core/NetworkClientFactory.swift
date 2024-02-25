import Foundation
import NetworkAPI

public struct NetworkClientFactoryImpl: NetworkClientFactory {
    public init() {}

    public func networkClient(with session: URLSessionProtocol) -> NetworkClient {
		let parametersEncoder = StandardRequestParametersEncoder(bodyEncoder: JSONEncoder())
		let adapter = StandardNetworkRequestAdapter(parametersEncoder: parametersEncoder)
        return NetworkClientImpl(session: session, requestAdapter: adapter)
    }
}
