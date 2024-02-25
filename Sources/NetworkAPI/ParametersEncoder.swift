import Foundation

/// A type for encoding ``RequestParameters`` in an ``URLRequest``.
public protocol ParametersEncoder {
	func encode(parameters: RequestParameter, in request: inout URLRequest)
}
