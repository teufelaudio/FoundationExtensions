// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

extension Result: ResultType {
    /// Initialize from a value
    ///
    /// - Parameter value: wrapped value when operation has succeeded
    public init(value: Success) {
        self = .success(value)
    }

    /// Initialize from an error
    ///
    /// - Parameter error: wrapped error when operation has failed
    public init(error: Failure) {
        self = .failure(error)
    }

    /// Identity, return itself. Necessary for protocol programming.
    public func asResult() -> Result<Success, Failure> {
        return self
    }
}
