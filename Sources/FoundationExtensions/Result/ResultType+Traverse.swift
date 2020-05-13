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
