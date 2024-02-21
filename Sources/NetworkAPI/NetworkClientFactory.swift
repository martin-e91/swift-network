import Foundation

public protocol NetworkClientFactory {
    func networkClient(with session: URLSessionProtocol) -> NetworkClient
}
