// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(Combine)
import Combine
import class Foundation.NSRecursiveLock

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {
    /// A Promise is a Publisher that lives in between First and Deferred.
    /// It will listen to one and only one event, and finish successfully, or finish with error without any successful output.
    /// It will hang until an event arrives from upstream. If the upstream is eager, it will be deferred, that means it won't
    /// be created (therefore, no side-effect possible) until the downstream sends demand (`.demand > .none`). This, of course,
    /// if it was not created yet before passed to this initializer.
    /// That way, you can safely add `Future` as upstream, for example, and be sure that its side-effect won't be started. The
    /// behaviour, then, will be similar to `Deferred<Future<Output, Failure>>`, however with some extra features such as better
    /// zips, and a run function to easily start the effect. The cancellation is possible and will be forwarded to the upstream
    /// if the effect had already started.
    /// Promises can be created from any Publisher, but only the first element will be relevant. It can also be created from
    /// hardcoded success or failure values, or from a Result. In any of these cases, the evaluation of the value will be deferred
    /// so be sure to use values with copy semantic (value type).
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public struct Promise<Success, Failure: Error>: PromiseType {
        public typealias Output = Success
        public typealias CompletionHandler = (Result<Success, Failure>) -> Void
        public typealias OperationClosure = (@escaping CompletionHandler) -> Cancellable

        struct SinkNotification {
            let receiveCompletion: (Subscribers.Completion<Failure>) -> Void
            let receiveValue: (Output) -> Void
        }
        typealias SinkClosure = (SinkNotification) -> AnyCancellable

        private let operation: SinkClosure

        /// A promise from an upstream publisher. Because this is an closure parameter, the upstream will become a factory
        /// and its creation will be deferred until there's some positive demand from the downstream.
        /// - Parameter upstream: a closure that creates an upstream publisher. This is an closure, so creation will be deferred.
        public init<P: Publisher>(_ upstream: @escaping () -> NonEmptyPublisher<P>) where P.Output == Success, P.Failure == Failure {
            operation = { sinkNotification in
                upstream()
                    .first()
                    .sink(
                        receiveCompletion: sinkNotification.receiveCompletion,
                        receiveValue: sinkNotification.receiveValue
                    )
            }
        }

        internal static func unsafe<P: Publisher>(upstreamUncheckedForEmptiness upstream: @escaping () -> P) -> Self
        where P.Output == Success, P.Failure == Failure {
            .init { NonEmptyPublisher.unsafe(nonEmptyUpstream: upstream()) }
        }

        public init(_ promise: @escaping () -> Promise<Success, Failure>)  {
            self = promise()
        }

        public init(operation: @escaping OperationClosure) {
            self.operation = { sinkNotification in
                let cancellable = operation { result in
                    switch result {
                    case let .failure(error):
                        sinkNotification.receiveCompletion(.failure(error))
                    case let .success(value):
                        sinkNotification.receiveValue(value)
                        sinkNotification.receiveCompletion(.finished)
                    }
                }

                return AnyCancellable {
                    cancellable.cancel()
                }
            }
        }

        public init(_ asyncFunc: @escaping () async throws -> Success) where Failure == Error {
            self.init { promise in
                let task = Task {
                    do {
                        let result = try await asyncFunc()
                        promise(.success(result))
                    } catch {
                        promise(.failure(error))
                    }
                }

                return AnyCancellable { task.cancel() }
            }
        }

        public init(_ asyncFunc: @escaping () async -> Success)  where Failure == Never {
            self.init { promise in
                let task = Task {
                    let result = await asyncFunc()
                    promise(.success(result))
                }

                return AnyCancellable { task.cancel() }
            }
        }

        /// This function is called to attach the specified `Subscriber` to this `Publisher` by `subscribe(_:)`
        ///
        /// - SeeAlso: `subscribe(_:)`
        /// - Parameters:
        ///     - subscriber: The subscriber to attach to this `Publisher`.
        ///                   once attached it can begin to receive values.
        public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Success == S.Input {
            subscriber.receive(subscription: Subscription(operation: operation, downstream: subscriber))
        }

        public var promise: Publishers.Promise<Success, Failure> {
            self
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.Promise {
    class Subscription<Downstream: Subscriber>: Combine.Subscription where Output == Downstream.Input, Failure == Downstream.Failure {
        private let lock = NSRecursiveLock()
        private var hasStarted = false
        private let operation: SinkClosure
        private let downstream: Downstream
        private var cancellable: AnyCancellable?

        public init(operation: @escaping SinkClosure, downstream: Downstream) {
            self.operation = operation
            self.downstream = downstream
        }

        func request(_ demand: Subscribers.Demand) {
            guard demand > .none else { return }

            lock.lock()
            let shouldRun = !hasStarted
            hasStarted = true
            lock.unlock()

            guard shouldRun else { return }

            cancellable = operation(SinkNotification(
                receiveCompletion: { [weak self] result in
                    switch result {
                    case .finished:
                        self?.downstream.receive(completion: .finished)
                    case let .failure(error):
                        self?.downstream.receive(completion: .failure(error))
                    }
                },
                receiveValue: { [weak self] value in
                    _ = self?.downstream.receive(value)
                    self?.downstream.receive(completion: .finished)
                }
            ))
        }

        func cancel() {
            cancellable?.cancel()
        }
    }
}
#endif
