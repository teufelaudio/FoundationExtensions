//
//  Reader+ResultType.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 29.05.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

extension Reader where Value: ResultType {
    public func mapResult<NewSuccess>(_ transform: @escaping (Value.Success) -> NewSuccess) -> Reader<Environment, Result<NewSuccess, Value.Failure>> {
        mapValue { $0.map(transform) }
    }

    public func mapResultError<NewFailure>(_ transform: @escaping (Value.Failure) -> NewFailure) -> Reader<Environment, Result<Value.Success, NewFailure>> {
        mapValue { $0.mapError(transform) }
    }

    public func bimapResult<NewSuccess, NewFailure>(
        _ transform: @escaping (Value.Success) -> NewSuccess,
        errorTransform: @escaping (Value.Failure) -> NewFailure
    ) -> Reader<Environment, Result<NewSuccess, NewFailure>> {
        mapValue { $0.map(transform).mapError(errorTransform) }
    }

    public func flatMapResult<NewResult: ResultType>(
        _ transform: @escaping (Value.Success) -> NewResult
    ) -> Reader<Environment, Result<NewResult.Success, Value.Failure>> where NewResult.Failure == Value.Failure {
        mapValue { $0.flatMap { transform($0).asResult() } }
    }

    public func flatMapResultError<NewResult: ResultType>(
        _ transform: @escaping (Value.Failure) -> NewResult
    ) -> Reader<Environment, Result<Value.Success, NewResult.Failure>> where NewResult.Success == Value.Success {
        mapValue { $0.flatMapError { transform($0).asResult() } }
    }
}
