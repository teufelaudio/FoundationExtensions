//
//  Publishers+FlatMapResult.swift
//  FoundationExtensions
//
//  Created by Thomas Mellenthin on 25.08.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

#if canImport(Combine)
import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {
    public struct FlatMapLatest<Upstream: Publisher, Downstream: Publisher>: Publisher where Upstream.Failure == Downstream.Failure {
        public typealias Output = Downstream.Output
        public typealias Failure = Upstream.Failure
        private let upstream: Upstream
        private let transform: (Upstream.Output) -> Downstream
        public init(_ upstream: Upstream, transform: @escaping (Upstream.Output) -> Downstream) {
            self.upstream = upstream
            self.transform = transform
        }
        public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            upstream
                .map(transform)
                .switchToLatest()
                .receive(subscriber: subscriber)
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
    public func flatMapLatest<NewPublisher: Publisher>(_ transform: @escaping (Output) -> NewPublisher) -> Publishers.FlatMapLatest<Self, NewPublisher>
    where NewPublisher.Failure == Failure {
        Publishers.FlatMapLatest(self, transform: transform)
    }
}

#endif
