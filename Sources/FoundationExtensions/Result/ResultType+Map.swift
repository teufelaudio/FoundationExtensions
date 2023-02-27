// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

// MARK: - Functor / Bifunctor
extension ResultType {
    /// Given a function that goes from Success to NewSuccess and another function that goes from Failure to NewFailure, transforms
    /// `Result<Success, Failure>` into a `Result<NewSuccess, NewFailure>`. Transforms either the successful case as well as the failure case.
    /// Maps both sides of your co-product.
    ///
    /// - Parameters:
    ///   - transform: a function that transforms Success to NewSuccess without any possible error in this operation
    ///   - errorTransform: a function that transforms Failure to NewFailure without any possible error in this operation
    /// - Returns: a new container having a successful case of NewSuccess (in case the original container was a successful case of Success),
    ///            or a new container having an failure case of NewFailure (in case the original container was an failure case of Failure).
    public func biMap<NewSuccess, NewFailure>(_ transform: (Success) -> NewSuccess,
                                              errorTransform: (Failure) -> NewFailure
    ) -> Result<NewSuccess, NewFailure> {
        return map(transform).mapError(errorTransform)
    }
}

// MARK: - Monad / Bimonad
extension ResultType {
    /// Given a function that goes from Success to Result<NewSuccess, NewFailure> and another function that goes from Failure
    /// to NewFailure, transforms `Result<Success, Failure>` into a `Result<NewSuccess, NewFailure>`.
    /// Transforms either the successful case as well as the failure case.
    /// If original container was an error, it transform the error from Failure to NewFailure, otherwise it will unwrap the
    /// value, and try to transform it, and because this operation can also fail, result could be either the value got
    /// from Success -> NewSuccess transformation or a new error.
    ///
    /// - Parameters:
    ///   - transform: a function that transforms Success to Result<NewSuccess, NewFailure>, a failable operation
    ///   - errorTransform: a function that transforms Failure to NewFailure without any possible error in this operation
    /// - Returns: a new container having a successful case of type NewFailure (in case the original container was a successful case
    ///            of type Success and transformation succeeded as well), or an error of type NewFailure that can be the
    ///            original container in case it was already an error, or a new error caused by the transformation.
    public func biFlatMap<NewSuccess, NewFailure>(_ transform: (Success) -> Result<NewSuccess, NewFailure>,
                                                  errorTransform: (Failure) -> Result<NewSuccess, NewFailure>
    ) -> Result<NewSuccess, NewFailure> {
        return fold(onSuccess: transform, onFailure: errorTransform)
    }

    /// Joins two result types into one, making a flat container out of a double-level container on both sides
    ///
    /// - Returns: flat result container
    public func flatten<NewResultType: ResultType>()
    -> NewResultType where Success == NewResultType, Failure == NewResultType {
        return fold(onSuccess: identity, onFailure: identity)
    }

    /// Joins two result types into one, making a flat container out of a double-level container on the left side
    ///
    /// - Returns: flat result container
    public func flattenLeft<NewResultType: ResultType>()
    -> NewResultType where Success == NewResultType, Failure == NewResultType.Failure {
        return fold(onSuccess: identity,
                    onFailure: { NewResultType(error: $0) })
    }
}

// MARK: - Applicative
extension ResultType {
    /// Given a transform function embedded in a Result container, unwrap it and apply to current result
    ///
    /// - Parameter transform: Transform function embedded in a Result container, which is able to transform Success -> NewSuccess
    /// - Returns: forwards any error (original from this container or the one in the transform parameter), or a successful
    ///            result of type NewSuccess if everything worked as expected
    public func apply<WrappedTransform, NewSuccess>(_ transform: WrappedTransform) -> Result<NewSuccess, Failure>
        where
        WrappedTransform: ResultType,
        WrappedTransform.Success == (Success) -> NewSuccess,
        WrappedTransform.Failure == Failure {
        return zip(self, transform).map { value, function in function(value) }
    }

    /// When we have a result type that might embed a function (OldValue) -> NewSuccess, we can use `call` it with a result
    /// that might embed `OldValue` to apply the transformation to its possible value.
    /// It's similar to `apply`, but works in the other direction, this time `self` contains the
    /// transformation and the parameter contains the value. But the expected result is the same.
    ///
    /// - Parameter value: a result that might wrap a value of type OldValue to be transformed
    /// - Returns: a result that may have NewSuccess, transformed from each wrapped value of type OldValue using the function
    ///            that might be wrapped on self. Or error of type Failure in case anything goes wrong.
    public func call<InputResultType, OldValue, NewSuccess>(_ value: InputResultType) -> Result<NewSuccess, Failure>
        where
        InputResultType: ResultType,
        InputResultType.Success == OldValue,
        InputResultType.Failure == Failure,
        Success == (OldValue) -> NewSuccess {
        return value.apply(self)
    }
}

extension Result {
    /// Curried map initializer. Start with the map's transform function, you will be given the function that maps any
    /// Result<Success, Failure) into Result<NewSuccess, Failure>
    ///
    /// - Parameter transform: a function that transforms Success to NewSuccess without any possible error in this operation
    /// - Returns: a function that receives a Result<Success, Failure> and returns Result<NewSuccess, Failure>
    public static func lift<NewSuccess>(_ transform: @escaping (Success) -> NewSuccess)
        -> (Result) -> Result<NewSuccess, Failure> {
        return { $0.map(transform) }
    }

    /// Curried flatMap initializer. Start with the flatMap's transform function, you will be given the function that
    /// flatMaps any Result<Success, Failure) into Result<NewSuccess, Failure>
    ///
    /// - Parameter transform: a function that transforms Success to Result<NewSuccess, Failure> with possible error in this operation
    /// - Returns: a function that receives a Result<Success, Failure> and returns Result<NewSuccess, Failure>
    public static func flatLift<NewSuccess>(_ transform: @escaping (Success) -> Result<NewSuccess, Failure>)
        -> (Result) -> Result<NewSuccess, Failure> {
        return { $0.flatMap(transform) }
    }
}

extension Result where Failure: Error {
    /// Transforms any concrete error type (DecodingError, for example) into the protocol type Swift.Error.
    /// Swift doesn't forward covariance to containers, so Array<Cat> can't be used directly where Array<Animal> is expected.
    /// The same way, if you have an operation that can return a failable Result<Success, DecodingError> but you need to pass into a
    /// function that expects Result<Success, Error>, the types will be incompatible, so you should upcastError that maps the
    /// right-hand side to Swift.Error.
    public func upcastError() -> Result<Success, Error> {
        return biMap(identity, errorTransform: { $0 as Error })
    }
}
