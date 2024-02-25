import Foundation

/// The source of a request's semantics.
///
///[Reference](https://www.rfc-editor.org/rfc/rfc9110.html#name-methods).
public enum HTTPMethod: String {
	/// Transfer a current representation of the target resource.
	case get = "GET"
	/// Same as GET, but do not transfer the response content.
	case head = "HEAD"
	/// Perform resource-specific processing on the request content.
	case post = "POST"
	/// Replace all current representations of the target resource with the request content.
	case put = "PUT"
	/// Remove all current representations of the target resource.
	case delete = "DELETE"
	/// Establish a tunnel to the server identified by the target resource.
	case connect = "CONNECT"
	/// Describe the communication options for the target resource.
	case options = "OPTIONS"
	/// Perform a message loop-back test along the path to the target resource.
	case trace = "TRACE"
}
