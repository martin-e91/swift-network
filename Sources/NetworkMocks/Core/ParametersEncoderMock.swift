import Foundation
import NetworkAPI

public final class ParametersEncoderMock: ParametersEncoder {
	public init() {}

	public var encodeRequestParameterUpdater: InoutParameterUpdater<URLRequest> = { _ in }
	public var encodeError: Error?
	public private(set) var encodeCallCount = 0
	public private(set) var encodeParametersParameter: RequestParameter?
	public func encode(parameters: RequestParameter, in request: inout URLRequest) throws {
		encodeCallCount += 1
		encodeParametersParameter = parameters
		if let encodeError {
			throw encodeError
		}
		encodeRequestParameterUpdater(&request)
	}
}
