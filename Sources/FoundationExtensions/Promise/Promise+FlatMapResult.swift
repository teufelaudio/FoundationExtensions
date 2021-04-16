//
//  Promise+FlatMapResult.swift
//  FoundationExtensions
//
//  Created by Luiz Rodrigo Martins Barbosa on 17.04.21.
//  Copyright © 2021 Lautsprecher Teufel GmbH. All rights reserved.
//

#if canImport(Combine)
import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.Promise {
    public func flatMapResult<T>(
        maxPublishers: Subscribers.Demand = .unlimited,
        _ transform: @escaping (Self.Output) -> Result<T, UpstreamFailure>
    ) -> Publishers.Promise<T, UpstreamFailure> {
        self.catch { (promiseError: PromiseError<UpstreamFailure>) -> AnyPublisher<Output, UpstreamFailure> in
            switch promiseError {
            case .completedWithoutValue:
                return Empty().eraseToAnyPublisher()
            case let .receivedError(error):
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
        .flatMap(maxPublishers: maxPublishers) { value in
            transform(value).publisher
        }
        .promise()
    }
}
#endif
