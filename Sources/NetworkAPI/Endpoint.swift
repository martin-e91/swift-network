import Foundation

public typealias PathComponents = [String]

/// An API endpoint.
public protocol Endpoint {
    /// The scheme subcomponent of the endpoint.
    ///
    /// In the `URL` `https://api.host.com/v1/resource/id`, calling `scheme` would return `"https"`.
    var scheme: String { get }

    /// The host subcomponent of the endpoint.
    ///
    /// In the `URL` `https://api.host.com/v1/resource/id`, calling `host` would return `"api.host.com"`.
    var host: String { get }

    /// The path subcomponent of the endpoint.
    ///
    /// In the `URL` `https://api.host.com/v1/resource/id`, calling `path` would return `["v1", "resource", "id"]`.
    var path: PathComponents { get }
}
