import Foundation

/// A closure to update an `inout` parameter.
public typealias InoutParameterUpdater<T> = (inout T) -> Void
