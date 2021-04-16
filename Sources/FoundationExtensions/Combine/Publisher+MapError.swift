//
//  Publisher+MapError.swift
//  FoundationExtensions
//
//  Created by Luiz Rodrigo Martins Barbosa on 17.04.21.
//  Copyright © 2021 Lautsprecher Teufel GmbH. All rights reserved.
//

#if canImport(Combine)
import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
    public func mapError<UpstreamError: Error, NewError: Error>(_ transform: @escaping (UpstreamError) -> NewError)
    -> Publishers.MapError<Self, PromiseError<NewError>> where Failure == PromiseError<UpstreamError> {
        mapError { (promiseError: PromiseError<UpstreamError>) -> PromiseError<NewError> in
            switch promiseError {
            case .completedWithoutValue:
                return .completedWithoutValue
            case let .receivedError(innerError):
                return .receivedError(transform(innerError))
            }
        }
    }
}
#endif
