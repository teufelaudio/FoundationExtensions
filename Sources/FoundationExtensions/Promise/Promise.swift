//
//  Promise.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 29.05.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

#if canImport(Combine)
import Combine
import class Foundation.NSRecursiveLock

public enum PromiseError<Failure: Error>: Error {
    case completedWithoutValue
    case receivedError(Failure)
}

extension PromiseError: Equatable where Failure: Equatable { }
extension PromiseError: Hashable where Failure: Hashable { }

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
    public struct Promise<Success, UpstreamFailure: Error>: PromiseType {
        public typealias Output = Success
        public typealias UpstreamFailure = UpstreamFailure
        public typealias Failure = PromiseError<UpstreamFailure>
        public typealias CompletionHandler = (Result<Success, UpstreamFailure>) -> Void
        public typealias OperationClosure = (@escaping CompletionHandler) -> Cancellable

        struct SinkNotification {
            let receiveCompletion: (Subscribers.Completion<UpstreamFailure>) -> Void
            let receiveValue: (Output) -> Void
        }
        typealias SinkClosure = (SinkNotification) -> AnyCancellable

        private let operation: SinkClosure

        /// A promise from an upstream publisher. Because this is an closure parameter, the upstream will become a factory
        /// and its creation will be deferred until there's some positive demand from the downstream.
        /// - Parameter upstream: a closure that creates an upstream publisher. This is an closure, so creation will be deferred.
        public init<P: Publisher>(_ upstream: @escaping () -> P) where P.Output == Success, P.Failure == UpstreamFailure {
            self.operation = { sinkNotification in
                upstream()
                    .first()
                    .sink(
                        receiveCompletion: sinkNotification.receiveCompletion,
                        receiveValue: sinkNotification.receiveValue
                    )
            }
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

        /// This function is called to attach the specified `Subscriber` to this `Publisher` by `subscribe(_:)`
        ///
        /// - SeeAlso: `subscribe(_:)`
        /// - Parameters:
        ///     - subscriber: The subscriber to attach to this `Publisher`.
        ///                   once attached it can begin to receive values.
        public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Success == S.Input {
            subscriber.receive(subscription: Subscription(operation: operation, downstream: subscriber))
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.Promise {
    class Subscription<Downstream: Subscriber>: Combine.Subscription where Output == Downstream.Input, PromiseError<UpstreamFailure> == Downstream.Failure {
        private let lock = NSRecursiveLock()
        private var hasStarted = false
        private var receivedValue = false
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
                    self?.lock.lock()
                    let completedSuccessully = self?.receivedValue ?? false
                    self?.lock.unlock()

                    if completedSuccessully {
                        self?.downstream.receive(completion: .finished)
                        return
                    }
                    switch result {
                    case .finished:
                        self?.downstream.receive(completion: .failure(.completedWithoutValue))
                    case let .failure(error):
                        self?.downstream.receive(completion: .failure(.receivedError(error)))
                    }
                },
                receiveValue: { [weak self] value in
                    self?.lock.lock()
                    self?.receivedValue = true
                    self?.lock.unlock()
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

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.Promise {
    public func mapError<NewError: Error>(_ transform: @escaping (UpstreamFailure) -> NewError) -> Publishers.Promise<Success, NewError> {
        self.catch { (promiseError: PromiseError<UpstreamFailure>) -> AnyPublisher<Success, NewError> in
            switch promiseError {
            case .completedWithoutValue:
                return Empty().eraseToAnyPublisher()
            case let .receivedError(error):
                return Fail(error: transform(error)).eraseToAnyPublisher()
            }
        }.promise
    }

    public func setFailureType<T: Error>(to failureType: T.Type) -> Publishers.Promise<Success, T> where UpstreamFailure == Never {
        self.catch { (promiseError: PromiseError<UpstreamFailure>) -> Empty<Success, T> in
            // If we are here, it's because the upstream threw .completedWithoutValue...
            // It's impossible for it to trigger .receivedError because UpstreamFailure is Never
            // Therefore, we send an empty publisher downstream, once converted to a promise, it
            // will retrigger .completedWithoutValue downstream as well, as soon as the Empty completes.
            Empty()
        }.promise
    }
}
#endif
