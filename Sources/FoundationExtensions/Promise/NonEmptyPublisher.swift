//
//  NonEmptyPublisher.swift
//  FoundationExtensions
//
//  Created by Luiz Rodrigo Martins Barbosa on 19.04.21.
//  Copyright © 2021 Lautsprecher Teufel GmbH. All rights reserved.
//

#if canImport(Combine)
import Combine
import Foundation

/// A Publisher that ensures that at least 1 value will be emitted before successful completion, but not necessarily in case of failure completion.
/// This requires a fallback success or error in case the upstream decides to terminate empty.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct NonEmptyPublisher<Upstream: Publisher>: Publisher {
    public typealias Output = Upstream.Output
    public typealias Failure = Upstream.Failure

    private let upstream: Upstream
    let fallback: () -> Result<Output, Failure>

    public init(upstream: Upstream, onEmpty fallback: @escaping () -> Result<Output, Failure>) {
        self.upstream = upstream
        self.fallback = fallback
    }

    private enum EmptyStream {
        case empty
        case someValue(Output)
    }

    public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        upstream
            .map(EmptyStream.someValue)
            .replaceEmpty(with: EmptyStream.empty)
            .flatMap { valueType -> AnyPublisher<Output, Failure> in
                switch valueType {
                case .empty:
                    switch fallback() {
                    case let .success(fallbackValue):
                        return Just(fallbackValue).setFailureType(to: Failure.self).eraseToAnyPublisher()
                    case let .failure(fallbackError):
                        return Fail(error: fallbackError).eraseToAnyPublisher()
                    }
                case let .someValue(value):
                    return Just(value).setFailureType(to: Failure.self).eraseToAnyPublisher()
                }
            }
            .subscribe(subscriber)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension NonEmptyPublisher where Upstream: PromiseType {
    public init(upstream: Upstream) {
        self.upstream = upstream
        self.fallback = { fatalError() }
    }
}
#endif
