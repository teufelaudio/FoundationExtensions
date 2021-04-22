//
//  PromiseType+Fold.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 25.01.19.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

#if canImport(Combine)
import Combine
import Foundation

// MARK: - Coproduct
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension PromiseType {
    /// Case folding for Promise. Given functions that convert either errors or wrapped values into the same type FoldedValue
    /// evaluates the promise and returns Deferred<FolderValue>.
    ///
    /// - Parameters:
    ///   - onSuccess: a function that, given a wrapped value `Success`, executes an operation that returns `TargetType`,
    ///                which will be the result of this function
    ///   - onFailure: a function that, given an error `Failure`, executes an operation that returns `TargetType`,
    ///                which will be the result of this function
    /// - Returns: the value produced by applying `ifFailure` to `failure` Promise, or `ifSuccess` to `success` Promise, any of them
    ///            translated into the same `Deferred<TargetType>`.
    public func fold<TargetType>(onSuccess: @escaping (Success) -> TargetType, onFailure: @escaping (Failure) -> TargetType)
    -> Publishers.Promise<TargetType, Never> {
        map(onSuccess)
            .catch { error in .init(value: onFailure(error)) }
    }

    /// Case analysis for Promise. When Promises runs, this step will evaluate possible results, run actions for them and
    /// complete with future Void when the analysis is done.
    ///
    /// - Parameters:
    ///   - ifSuccess: a function that, given a wrapped `Success`, executes an operation with no return value
    ///   - ifFailure: a function that, given an error `Failure`, executes an operation with no return value
    /// - Returns: returns a future Void, indicating that Promise ran and evaluated the two possible scenarios, success or failure.
    public func analysis(ifSuccess: @escaping (Success) -> Void, ifFailure: @escaping (Failure) -> Void)
    -> Publishers.Promise<Void, Never> {
        fold(onSuccess: ifSuccess, onFailure: ifFailure)
    }

    /// If this promise results in an error, executes the provided closure passing the inner error
    ///
    /// - Parameter run: the block to execute in case this is an error
    /// - Returns: returns always `self` with no changes, for chaining purposes.
    public func onError(_ run: @escaping (Failure) -> Void) -> Publishers.Promise<Success, Failure> {
        handleEvents(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    run(error)
                }
            }
        ).promise
    }
}
#endif
