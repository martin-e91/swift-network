import Foundation
import NetworkAPI

public final class ParametersEncoderMock: ParametersEncoder {
	public init() {}

	public private(set) var encodeCallCount = 0
	public private(set) var encodeParametersParameter: RequestParameter?
	public func encode(parameters: RequestParameter, in request: inout URLRequest) {
		encodeCallCount += 1
		encodeParametersParameter = parameters
	}
}
