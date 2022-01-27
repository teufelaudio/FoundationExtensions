import Combine
import Foundation

extension Publishers {
    public struct FlatMapEx<Upstream: Publisher, Downstream: Publisher> where Upstream.Failure == Downstream.Failure {
        private let upstream: Upstream
        private let transform: (Upstream.Output) -> Downstream

        public init(_ upstream: Upstream, _ transform: @escaping (Upstream.Output) -> Downstream) {
            self.upstream = upstream
            self.transform = transform
        }
    }
}

extension Publishers.FlatMapEx: Publisher {
    public typealias Output = Downstream.Output
    public typealias Failure = Downstream.Failure

    public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        subscriber.receive(
            subscription: Subscription(subscriber: subscriber, upstream: upstream, transform: transform)
        )
    }
}

extension Publishers.FlatMapEx {
    class Subscription<Subscriber: Combine.Subscriber>: Combine.Subscription where Subscriber.Failure == Failure, Subscriber.Input == Output {
        private var buffer: DemandBuffer<Subscriber>?
        private let lock = NSRecursiveLock()
        private var hasStarted = false
        private var hasFinished = false
        private let upstream: Upstream
        private let transform: (Upstream.Output) -> Downstream
        private var upstreamSubscription: AnyCancellable?
        private var cancellables = Set<AnyCancellable>()

        init(subscriber: Subscriber, upstream: Upstream, transform: @escaping (Upstream.Output) -> Downstream) {
            self.upstream = upstream
            self.transform = transform
            self.buffer = DemandBuffer(subscriber: subscriber)
        }

        func request(_ demand: Subscribers.Demand) {
            guard let buffer = self.buffer,
                  demand > 0
            else { return }

            lock.lock()
            defer { lock.unlock() }

            if !hasStarted && !hasFinished {
                hasStarted = true
                start()
            }

            if !hasFinished {
                // Flush buffer
                // If subscriber asked for 10 but we had only 3 in the buffer, it will return 7 representing the remaining demand
                // We actually don't care about that number, as once we buffer more items they will be flushed right away, so simply ignore it
                _ = buffer.demand(demand)
            }
        }

        func start() {
            let transform = self.transform
            upstreamSubscription = upstream
                .flatMap(transform)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        self?.lock.lock()
                        self?.hasFinished = true
                        self?.lock.unlock()
                        self?.buffer?.complete(completion: completion)
                        self?.buffer = nil
                        self?.cancellables = .init()
                    },
                    receiveValue: { [weak self] value in
                        _ = self?.buffer?.buffer(value: value)
                    }
                )
        }

        func cancel() {
            lock.lock()
            hasFinished = true
            lock.unlock()

            upstreamSubscription = nil
            buffer?.complete(completion: .finished)
            cancellables = .init()
            buffer = nil
        }
    }
}

extension Publisher {
    public func flatMapEx<Downstream: Publisher>(_ transform: @escaping (Output) -> Downstream) -> Publishers.FlatMapEx<Self, Downstream>
    where Downstream.Failure == Failure {
        Publishers.FlatMapEx(self, transform)
    }
}
