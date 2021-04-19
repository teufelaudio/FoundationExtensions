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
        self.init { Empty().nonEmpty(fallback: { .success(value) }) }
    }

    /// A promise from a hardcoded error
    /// - Parameter error: a hardcoded error. It's gonna be evaluated on demand from downstream
    public init(error: Failure) {
        self.init { Empty().nonEmpty(fallback: { .failure(error) }) }
    }

    /// A promise from a hardcoded result value
    /// - Parameter value: a hardcoded result value. It's gonna be evaluated on demand from downstream
    public init(result: Result<Success, Failure>) {
        self.init { Empty().nonEmpty(fallback: { result }) }
    }

    /// Creates a new promise by evaluating a synchronous throwing closure, capturing the
    /// returned value as a success, or any thrown error as a failure.
    ///
    /// - Parameters:
    ///   - body: A throwing closure to evaluate.
    ///   - errorTransform: a way to transform the throwing error from type `Error` to type `Failure` of this `PromiseType`
    // https://www.fivestars.blog/articles/disfavoredOverload/
    @_disfavoredOverload
    public init(catching body: @escaping () throws -> Success, errorTransform: (Error) -> Failure) {
        self.init(result: Result { try body() }.mapError(errorTransform))
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension PromiseType where Failure == Error {
    /// Creates a new promise by evaluating a synchronous throwing closure, capturing the
    /// returned value as a success, or any thrown error as a failure.
    ///
    /// - Parameter body: A throwing closure to evaluate.
    // https://www.fivestars.blog/articles/disfavoredOverload/
    @_disfavoredOverload
    public init(catching body: @escaping () throws -> Success) {
        self.init(result: Result { try body() })
    }
}
#endif
