import Foundation

/// A type for encoding ``RequestParameter`` in an ``URLRequest``.
public protocol ParametersEncoder {
	func encode(parameters: RequestParameter, in request: inout URLRequest) throws
}
