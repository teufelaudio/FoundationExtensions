//
//  ResultType+Traverse.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 30.11.18.
//  Copyright © 2018 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

extension ResultType {
    // Traverse Result, Result
    public func traverse<NewSuccess, NewFailure>(_ transform: (Success) -> Result<NewSuccess, NewFailure>)
        -> Result<Result<NewSuccess, Failure>, NewFailure> {
        return fold(onSuccess: { value in transform(value).map(Result<NewSuccess, Failure>.success) },
                    onFailure: { error in .success(.failure(error)) })
    }

    // Traverse Array, Result
    public func traverse<ArrayElement>(_ transform: (Success) -> [ArrayElement]) -> [Result<ArrayElement, Failure>] {
        return fold(onSuccess: { value in transform(value).map(Result<ArrayElement, Failure>.success) },
                    onFailure: { error in [.failure(error)] })
    }

    // Traverse Optional, Result
    public func traverse<OptionalWrapped>(_ transform: (Success) -> OptionalWrapped?) -> Result<OptionalWrapped, Failure>? {
        return fold(onSuccess: { value in transform(value).map(Result<OptionalWrapped, Failure>.success) },
                    onFailure: { error in .failure(error) })
    }
}

#if canImport(Combine)
import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension ResultType {
    // Traverse Publisher, Result
    public func traverse<P: Publisher>(_ transform: @escaping (Success) -> P)
    -> AnyPublisher<Result<P.Output, Never>, P.Failure> where P.Failure == Failure {
        fold(
            onSuccess: { value in
                transform(value).map(Result<P.Output, Never>.success).eraseToAnyPublisher()
            },
            onFailure: { error in
                Fail(error: error).eraseToAnyPublisher()
            }
        )
    }
}
#endif
