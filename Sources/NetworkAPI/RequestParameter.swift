import Foundation

/// Parameters kind that can be specified on the request.
public enum RequestParameter {
	case query([String: String])
	case body(Encodable)
}
