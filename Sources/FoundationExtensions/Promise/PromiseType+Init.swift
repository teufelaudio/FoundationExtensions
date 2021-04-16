//
//  PromiseType+Init.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 11.01.19.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

#if canImport(Combine)
import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension PromiseType {
    /// A promise from a hardcoded successful value
    /// - Parameter value: a hardcoded successful value. It's gonna be evaluated on demand from downstream
    public init(value: Success) {
        self.init { Just(value).mapError(absurd) }
    }

    /// A promise from a hardcoded error
    /// - Parameter error: a hardcoded error. It's gonna be evaluated on demand from downstream
    public init(error: UpstreamFailure) {
        self.init { Fail(error: error) }
    }

    /// A promise from a hardcoded error
    /// - Parameter error: a hardcoded error. It's gonna be evaluated on demand from downstream
    public init(error: PromiseError<UpstreamFailure>) {
        switch error {
        case .completedWithoutValue:
            self.init { Empty() }
        case let .receivedError(error):
            self.init { Fail(error: error) }
        }
    }

    /// A promise from a hardcoded result value
    /// - Parameter value: a hardcoded result value. It's gonna be evaluated on demand from downstream
    public init(result: Result<Success, UpstreamFailure>) {
        self.init { result.publisher }
    }

    /// A promise from a hardcoded result value
    /// - Parameter value: a hardcoded result value. It's gonna be evaluated on demand from downstream
    public init(result: Result<Success, PromiseError<UpstreamFailure>>) {
        switch result {
        case let .success(value):
            self.init(value: value)
        case .failure(.completedWithoutValue):
            self.init { Empty() }
        case let .failure(.receivedError(error)):
            self.init { Fail(error: error) }
        }
    }

    /// Creates a new promise by evaluating a synchronous throwing closure, capturing the
    /// returned value as a success, or any thrown error as a failure.
    ///
    /// - Parameters:
    ///   - body: A throwing closure to evaluate.
    ///   - errorTransform: a way to transform the throwing error from type `Error` to type `Failure` of this `PromiseType`
    public init(catching body: @escaping () throws -> Success, errorTransform: (Error) -> UpstreamFailure) {
        self.init(result: Result { try body() }.mapError(errorTransform))
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension PromiseType where UpstreamFailure == Error {
    /// Creates a new promise by evaluating a synchronous throwing closure, capturing the
    /// returned value as a success, or any thrown error as a failure.
    ///
    /// - Parameter body: A throwing closure to evaluate.
    public init(catching body: @escaping () throws -> Success) {
        self.init(result: Result { try body() })
    }
}
#endif
