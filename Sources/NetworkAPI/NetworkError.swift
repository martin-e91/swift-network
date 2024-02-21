import Foundation

/// An error occurring in the network layer.
public enum NetworkError: Error {
    /// The request's `URL` is invalid.
    case invalidRequestURL
}
