// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

// MARK: - Coproduct
extension ResultType {
    /// Case folding for Result. Given functions that convert either errors or wrapped values into the same type FoldedValue
    /// evaluates the result and returns B.
    ///
    /// - Parameters:
    ///   - onSuccess: a function that, given a wrapped value `Success`, executes an operation that returns `TargetType`,
    ///                which will be the result of this function
    ///   - onFailure: a function that, given an error `Failure`, executes an operation that returns `TargetType`,
    ///                which will be the result of this function
    /// - Returns: the value produced by applying `ifFailure` to `failure` Result, or `ifSuccess` to `success` Result, any of them
    ///            translated into the same `TargetType`.
    public func fold<TargetType>(onSuccess: (Success) -> TargetType, onFailure: (Failure) -> TargetType) -> TargetType {
        switch asResult() {
        case .success(let value):
            return onSuccess(value)
        case .failure(let error):
            return onFailure(error)
        }
    }

    /// Case analysis for Result.
    ///
    /// - Parameters:
    ///   - ifSuccess: a function that, given a wrapped `Success`, executes an operation with no return value
    ///   - ifFailure: a function that, given an error `Failure`, executes an operation with no return value
    /// - Returns: returns always `self` with no changes, for chaining purposes. It is a discardable result.
    @discardableResult
    public func analysis(ifSuccess: (Success) -> Void, ifFailure: (Failure) -> Void) -> Self {
        fold(onSuccess: ifSuccess, onFailure: ifFailure)
        return self
    }

    /// If this result is an error, executes the provided closure passing the inner error
    ///
    /// - Parameter run: the block to execute in case this is an error
    /// - Returns: returns always `self` with no changes, for chaining purposes. It is a discardable result.
    @discardableResult
    public func onError(_ run: (Failure) -> Void) -> Self {
        return analysis(ifSuccess: { _ in },
                        ifFailure: run)
    }
}
