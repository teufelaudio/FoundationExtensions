//
//  PromiseType+DefaultOperators.swift
//  FoundationExtensions
//
//  Created by Luiz Rodrigo Martins Barbosa on 19.04.21.
//  Copyright © 2021 Lautsprecher Teufel GmbH. All rights reserved.
//
#if canImport(Combine)
import Combine
import Foundation


@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)

// The stock publisher `Just` overrides most Publisher operators from the base protocol, to implement alternatives that return `Just` and not
// `Publisher.Map<Just>` or so. This allows us to execute a chain of operations to a Just publisher and remain in the Just world, following its
// constraints, traits and rules.
// https://developer.apple.com/documentation/combine/just
// For Promise this is also important. Promise is not only a very important Publisher, as most cases will complete with a single value only, but
// also it's the one that demands more chained operations. Leaving the world of promises means giving up on its main constraint: the upstream must
// emit one value before completing with success (or completes with failure regardless of value emission). For that reason, let's override the default
// operators to ensure they will return Promise, and not a different publisher that loses this trait.
// This can be done for any operator that makes sense and that doesn't filter the output. For example, `first` in a Promise is useless, as Promise
// will return only one element anyway, but it can be implemented. However, `first(where predicate:)` is dangerous, because it could filter out the
// only emission from this Promise and no emission would be sent downstream. In that case, we should keep this operator emitting Publisher, as we
// can't ensure anymore that it will be NonEmpty. So this must be evaluated case by case.
extension PromiseType {
    public func map<T>(_ transform: @escaping (Output) -> T) -> Publishers.Promise<T, Failure> {
        Publishers.Promise { self.eraseToAnyPublisher().map(transform) }
    }

    public func tryMap<T>(_ transform: @escaping (Output) throws -> T) -> Publishers.Promise<T, Error> {
        Publishers.Promise { self.eraseToAnyPublisher().tryMap(transform) }
    }

    public func mapError<E: Error>(_ transform: @escaping (Failure) -> E) -> Publishers.Promise<Output, E> {
        Publishers.Promise { self.eraseToAnyPublisher().mapError(transform) }
    }

    public func `catch`<F: Error>(_ handler: @escaping (Failure) -> Publishers.Promise<Output, F>) -> Publishers.Promise<Output, F> {
        Publishers.Promise { self.eraseToAnyPublisher().catch(handler) }
    }

    public func handleEvents(
        receiveSubscription: ((Subscription) -> Void)? = nil,
        receiveOutput: ((Self.Output) -> Void)? = nil,
        receiveCompletion: ((Subscribers.Completion<Self.Failure>) -> Void)? = nil,
        receiveCancel: (() -> Void)? = nil,
        receiveRequest: ((Subscribers.Demand) -> Void)? = nil)
    -> Publishers.Promise<Output, Failure> {
        Publishers.Promise {
            self.eraseToAnyPublisher().handleEvents(
                receiveSubscription: receiveSubscription,
                receiveOutput: receiveOutput,
                receiveCompletion: receiveCompletion,
                receiveCancel: receiveCancel,
                receiveRequest: receiveRequest
            )
        }
    }

    public func print(_ prefix: String = "", to stream: TextOutputStream? = nil) -> Publishers.Promise<Output, Failure> {
        Publishers.Promise { self.eraseToAnyPublisher().print(prefix, to: stream) }
    }

    public func flatMapResult<T>(maxPublishers: Subscribers.Demand = .unlimited, _ transform: @escaping (Output) -> Result<T, Failure>) -> Publishers.Promise<T, Failure> {
        Publishers.Promise { self.eraseToAnyPublisher().flatMapResult(maxPublishers: maxPublishers, transform) }
    }

    public func flatMap<O>(maxPublishers: Subscribers.Demand = .unlimited, _ transform: @escaping (Output) -> Publishers.Promise<O, Never>) -> Publishers.Promise<O, Failure> {
        Publishers.Promise { self.eraseToAnyPublisher().flatMap(maxPublishers: maxPublishers) { transform($0).setFailureType(to: Failure.self) } }
    }

    public func flatMap<O, E: Error>(maxPublishers: Subscribers.Demand = .unlimited, _ transform: @escaping (Output) -> Publishers.Promise<O, E>) -> Publishers.Promise<O, E> where Failure == Never {
        Publishers.Promise { self.eraseToAnyPublisher().setFailureType(to: E.self).flatMap(maxPublishers: maxPublishers, transform) }
    }

    public func flatMap<O>(maxPublishers: Subscribers.Demand = .unlimited, _ transform: @escaping (Output) -> Publishers.Promise<O, Failure>) -> Publishers.Promise<O, Failure> {
        Publishers.Promise { self.eraseToAnyPublisher().flatMap(maxPublishers: maxPublishers, transform) }
    }

    public func contains(_ output: Output) -> Publishers.Promise<Bool, Failure> where Output: Equatable {
        Publishers.Promise { self.eraseToAnyPublisher().contains(output) }
    }

    public func allSatisfy(_ predicate: @escaping (Output) -> Bool) -> Publishers.Promise<Bool, Failure> {
        Publishers.Promise { self.eraseToAnyPublisher().allSatisfy(predicate) }
    }

    public func tryAllSatisfy(_ predicate: @escaping (Output) throws -> Bool) -> Publishers.Promise<Bool, Error> {
        Publishers.Promise { self.eraseToAnyPublisher().tryAllSatisfy(predicate) }
    }

    public func contains(where predicate: @escaping (Output) -> Bool) -> Publishers.Promise<Bool, Failure> {
        Publishers.Promise { self.eraseToAnyPublisher().contains(where: predicate) }
    }

    public func tryContains(where predicate: @escaping (Output) throws -> Bool) -> Publishers.Promise<Bool, Error> {
        Publishers.Promise { self.eraseToAnyPublisher().tryContains(where: predicate) }
    }

    public func collect() -> Publishers.Promise<[Output], Failure> {
        Publishers.Promise { self.eraseToAnyPublisher().collect() }
    }

    public func count() -> Publishers.Promise<Int, Failure> {
        Publishers.Promise { self.eraseToAnyPublisher().count() }
    }

    public func first() -> Self { self }

    public func last() -> Self { self }

    public func replaceError(with output: Output) -> Publishers.Promise<Output, Never> {
        Publishers.Promise { self.eraseToAnyPublisher().replaceError(with: output) }
    }

    public func replaceEmpty(with output: Output) -> Publishers.Promise<Output, Failure> {
        Publishers.Promise { self.eraseToAnyPublisher().replaceEmpty(with: output) }
    }


    public func retry(_ times: Int) -> Publishers.Promise<Output, Failure> {
        Publishers.Promise { self.eraseToAnyPublisher().retry(times) }
    }

    public func scan<T>(_ initialResult: T, _ nextPartialResult: @escaping (T, Output) -> T) -> Publishers.Promise<T, Failure> {
        Publishers.Promise { self.eraseToAnyPublisher().scan(initialResult, nextPartialResult) }
    }

    public func tryScan<T>(_ initialResult: T, _ nextPartialResult: @escaping (T, Output) throws -> T) -> Publishers.Promise<T, Error> {
        Publishers.Promise { self.eraseToAnyPublisher().tryScan(initialResult, nextPartialResult) }
    }

    public func setFailureType<E: Error>(to failureType: E.Type) -> Publishers.Promise<Output, E> where Failure == Never {
        Publishers.Promise { self.eraseToAnyPublisher().setFailureType(to: failureType) }
    }

    public func delay<S: Scheduler>(
        for interval: S.SchedulerTimeType.Stride,
        tolerance: S.SchedulerTimeType.Stride? = nil,
        scheduler: S,
        options: S.SchedulerOptions? = nil
    ) -> Publishers.Promise<Output, Failure> {
        Publishers.Promise { self.eraseToAnyPublisher().delay(for: interval, tolerance: tolerance, scheduler: scheduler, options: options) }
    }

    public func timeout<S>(
        _ interval: S.SchedulerTimeType.Stride,
        scheduler: S,
        options: S.SchedulerOptions? = nil,
        customError: @escaping () -> Failure
    ) -> Publishers.Promise<Output, Failure> where S : Scheduler {
        Publishers.Promise {
            self.eraseToAnyPublisher().timeout(interval, scheduler: scheduler, options: options, customError: customError)
        }
    }

    @available(*, deprecated, message: "Don't call .promise in a Promise")
    public var promise: Publishers.Promise<Success, Failure> {
        self as? Publishers.Promise ?? Publishers.Promise { self }
    }
}
#endif
