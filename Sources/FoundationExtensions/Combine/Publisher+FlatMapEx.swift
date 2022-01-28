import Combine
import Foundation

extension Publishers {
    /// Same as Publishers.FlatMap, but it cancels the upstream in case the flatMap block finishes with error.
    public struct FlatMapEx<Upstream: Publisher, Downstream: Publisher>: Publisher where Upstream.Failure == Downstream.Failure {
        public typealias Output = Downstream.Output
        public typealias Failure = Downstream.Failure

        private let upstream: Upstream
        private let transform: (Upstream.Output) -> Downstream
        private let canceller = PassthroughSubject<Void, Never>()

        public init(_ upstream: Upstream, _ transform: @escaping (Upstream.Output) -> Downstream) {
            self.upstream = upstream
            self.transform = transform
        }

        public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
            upstream
                .prefix(untilOutputFrom: canceller)
                .flatMap(transform)
                .handleEvents(receiveCompletion: { [weak canceller] completion in
                    guard case .failure = completion else { return }
                    canceller?.send()
                })
                .receive(subscriber: subscriber)
        }
    }
}

extension Publisher {
    /// Same as Publishers.FlatMap, but it cancels the upstream in case the flatMap block finishes with error.
    public func flatMapEx<Downstream: Publisher>(_ transform: @escaping (Output) -> Downstream) -> Publishers.FlatMapEx<Self, Downstream>
    where Downstream.Failure == Failure {
        .init(self, transform)
    }
}
