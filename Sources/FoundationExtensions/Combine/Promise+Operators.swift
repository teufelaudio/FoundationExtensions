// Copyright © 2025 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(Combine)
import Combine
import OSLog

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.Promise: Publisher {
    @inlinable
    public func receive<S: Subscriber>(subscriber: S)
    where Output == S.Input, Failure == S.Failure {
        publisher.receive(subscriber: subscriber)
    }

    @inlinable
    public func subscribe(_ subscriber: some Subscriber<Output, Failure>) {
        publisher.subscribe(subscriber)
    }

    @inlinable
    public func subscribe(_ subscriber: some Subject<Output, Failure>) -> AnyCancellable {
        publisher.subscribe(subscriber)
    }

    @inlinable
    public func map<T>(_ transform: @escaping (Output) -> T) -> Publishers.Promise<T, Failure> {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<T, Failure> {
            publisher.map(transform).assertPromise("Publishers.Promise.map(_:)")
        }
        return open(publisher)
    }

    @inlinable
    public func tryMap<T>(_ transform: @escaping (Output) throws -> T) -> Publishers.Promise<T, any Error> {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<T, any Error> {
            publisher.tryMap(transform).assertPromise("Publishers.Promise.tryMap(_:)")
        }
        return open(publisher)
    }

    @inlinable
    public func mapError<E: Error>(_ transform: @escaping (Failure) -> E) -> Publishers.Promise<Output, E> {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<Output, E> {
            publisher.mapError(transform).assertPromise("Publishers.Promise.mapError(_:)")
        }
        return open(publisher)
    }

    @inlinable
    public func replaceNil<T>(with output: T) -> Publishers.Promise<T, Failure> where Self.Output == T? {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<T, Failure> {
            publisher.replaceNil(with: output).assertPromise("Publishers.Promise.replaceNil(with:)")
        }
        return open(publisher)
    }

    @inlinable
    public func replaceError(with output: Output) -> Publishers.Promise<Output, Never> {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<Output, Never> {
            publisher.replaceError(with: output).assertPromise("Publishers.Promise.replaceError(with:)")
        }
        return open(publisher)
    }

    @inlinable
    public func contains(where predicate: @escaping (Output) -> Bool) -> Publishers.Promise<Bool, Failure> {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<Bool, Failure> {
            publisher.contains(where: predicate).assertPromise("Publishers.Promise.contains(where:)")
        }
        return open(publisher)
    }

    @inlinable
    public func tryContains(where predicate: @escaping (Output) throws -> Bool) -> Publishers.Promise<Bool, any Error> {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<Bool, any Error> {
            publisher.tryContains(where: predicate).assertPromise("Publishers.Promise.tryContains(where:)")
        }
        return open(publisher)
    }

    @inlinable
    public static func zip<T, S>(
        _ p1: Publishers.Promise<T, Failure>,
        _ p2: Publishers.Promise<S, Failure>
    ) -> Publishers.Promise<Output, Failure> where Output == (T, S) {
        Publishers.Zip(p1, p2).assertPromise("Publishers.Promise.zip(_:_:)")
    }

    @inlinable
    public static func zip<T, S, G>(
        _ p1: Publishers.Promise<T, Failure>,
        _ p2: Publishers.Promise<S, Failure>,
        _ p3: Publishers.Promise<G, Failure>
    ) -> Publishers.Promise<Output, Failure> where Output == (T, S, G) {
        Publishers.Zip3(p1, p2, p3).assertPromise("Publishers.Promise.zip(_:_:_:)")
    }

    @inlinable
    public static func zip<T, S, G, H>(
        _ p1: Publishers.Promise<T, Failure>,
        _ p2: Publishers.Promise<S, Failure>,
        _ p3: Publishers.Promise<G, Failure>,
        _ p4: Publishers.Promise<H, Failure>
    ) -> Publishers.Promise<Output, Failure> where Output == (T, S, G, H) {
        Publishers.Zip4(p1, p2, p3, p4).assertPromise("Publishers.Promise.zip(_:_:_:_:)")
    }

    @inlinable
    public static func zip<T, S, G, H, J>(
        _ p1: Publishers.Promise<T, Failure>,
        _ p2: Publishers.Promise<S, Failure>,
        _ p3: Publishers.Promise<G, Failure>,
        _ p4: Publishers.Promise<H, Failure>,
        _ p5: Publishers.Promise<J, Failure>
    ) -> Publishers.Promise<Output, Failure> where Output == (T, S, G, H, J) {
        Publishers.Promise<(T, (S, G, H, J)), Failure>.zip(
            p1,
            Publishers.Promise<(S, G, H, J), Failure>.zip(p2, p3, p4, p5)
        )
        .map { ($0, $1.0, $1.1, $1.2, $1.3) }
    }

    @inlinable
    public static func zip<T, S, G, H, J, K>(
        _ p1: Publishers.Promise<T, Failure>,
        _ p2: Publishers.Promise<S, Failure>,
        _ p3: Publishers.Promise<G, Failure>,
        _ p4: Publishers.Promise<H, Failure>,
        _ p5: Publishers.Promise<J, Failure>,
        _ p6: Publishers.Promise<K, Failure>
    ) -> Publishers.Promise<Output, Failure> where Output == (T, S, G, H, J, K) {
        Publishers.Promise<(T, (S, G, H, J, K)), Failure>.zip(
            p1,
            Publishers.Promise<(S, G, H, J, K), Failure>.zip(p2, p3, p4, p5, p6)
        )
        .map { ($0, $1.0, $1.1, $1.2, $1.3, $1.4) }
    }

    @inlinable
    public static func zip<T, S, G, H, J, K, L>(
        _ p1: Publishers.Promise<T, Failure>,
        _ p2: Publishers.Promise<S, Failure>,
        _ p3: Publishers.Promise<G, Failure>,
        _ p4: Publishers.Promise<H, Failure>,
        _ p5: Publishers.Promise<J, Failure>,
        _ p6: Publishers.Promise<K, Failure>,
        _ p7: Publishers.Promise<L, Failure>
    ) -> Publishers.Promise<Output, Failure> where Output == (T, S, G, H, J, K, L) {
        Publishers.Promise<(T, (S, G, H, J, K, L)), Failure>.zip(
            p1,
            Publishers.Promise<(S, G, H, J, K, L), Failure>.zip(p2, p3, p4, p5, p6, p7)
        )
        .map { ($0, $1.0, $1.1, $1.2, $1.3, $1.4, $1.5) }
    }

    @inlinable
    public static func zip<T, S, G, H, J, K, L, M>(
        _ p1: Publishers.Promise<T, Failure>,
        _ p2: Publishers.Promise<S, Failure>,
        _ p3: Publishers.Promise<G, Failure>,
        _ p4: Publishers.Promise<H, Failure>,
        _ p5: Publishers.Promise<J, Failure>,
        _ p6: Publishers.Promise<K, Failure>,
        _ p7: Publishers.Promise<L, Failure>,
        _ p8: Publishers.Promise<M, Failure>
    ) -> Publishers.Promise<Output, Failure> where Output == (T, S, G, H, J, K, L, M) {
        Publishers.Promise<(T, (S, G, H, J, K, L, M)), Failure>.zip(
            p1,
            Publishers.Promise<(S, G, H, J, K, L, M), Failure>.zip(p2, p3, p4, p5, p6, p7, p8)
        )
        .map { ($0, $1.0, $1.1, $1.2, $1.3, $1.4, $1.5, $1.6) }
    }

    @inlinable
    public static func zip<T, S, G, H, J, K, L, M, N>(
        _ p1: Publishers.Promise<T, Failure>,
        _ p2: Publishers.Promise<S, Failure>,
        _ p3: Publishers.Promise<G, Failure>,
        _ p4: Publishers.Promise<H, Failure>,
        _ p5: Publishers.Promise<J, Failure>,
        _ p6: Publishers.Promise<K, Failure>,
        _ p7: Publishers.Promise<L, Failure>,
        _ p8: Publishers.Promise<M, Failure>,
        _ p9: Publishers.Promise<N, Failure>
    ) -> Publishers.Promise<Output, Failure> where Output == (T, S, G, H, J, K, L, M, N) {
        Publishers.Promise<(T, (S, G, H, J, K, L, M, N)), Failure>.zip(
            p1,
            Publishers.Promise<(S, G, H, J, K, L, M, N), Failure>.zip(p2, p3, p4, p5, p6, p7, p8, p9)
        )
        .map { ($0, $1.0, $1.1, $1.2, $1.3, $1.4, $1.5, $1.6, $1.7) }
    }

    @inlinable
    public static func zip<T, S, G, H, J, K, L, M, N, O>(
        _ p1: Publishers.Promise<T, Failure>,
        _ p2: Publishers.Promise<S, Failure>,
        _ p3: Publishers.Promise<G, Failure>,
        _ p4: Publishers.Promise<H, Failure>,
        _ p5: Publishers.Promise<J, Failure>,
        _ p6: Publishers.Promise<K, Failure>,
        _ p7: Publishers.Promise<L, Failure>,
        _ p8: Publishers.Promise<M, Failure>,
        _ p9: Publishers.Promise<N, Failure>,
        _ p10: Publishers.Promise<O, Failure>
    ) -> Publishers.Promise<Output, Failure> where Output == (T, S, G, H, J, K, L, M, N, O) {
        Publishers.Promise<(T, (S, G, H, J, K, L, M, N, O)), Failure>.zip(
            p1,
            Publishers.Promise<(S, G, H, J, K, L, M, N, O), Failure>.zip(p2, p3, p4, p5, p6, p7, p8, p9, p10)
        )
        .map { ($0, $1.0, $1.1, $1.2, $1.3, $1.4, $1.5, $1.6, $1.7, $1.8) }
    }

    @inlinable
    public static func zip<T, S, G, H, J, K, L, M, N, O, P>(
        _ p1: Publishers.Promise<T, Failure>,
        _ p2: Publishers.Promise<S, Failure>,
        _ p3: Publishers.Promise<G, Failure>,
        _ p4: Publishers.Promise<H, Failure>,
        _ p5: Publishers.Promise<J, Failure>,
        _ p6: Publishers.Promise<K, Failure>,
        _ p7: Publishers.Promise<L, Failure>,
        _ p8: Publishers.Promise<M, Failure>,
        _ p9: Publishers.Promise<N, Failure>,
        _ p10: Publishers.Promise<O, Failure>,
        _ p11: Publishers.Promise<P, Failure>
    ) -> Publishers.Promise<Output, Failure> where Output == (T, S, G, H, J, K, L, M, N, O, P) {
        Publishers.Promise<(T, (S, G, H, J, K, L, M, N, O, P)), Failure>.zip(
            p1,
            Publishers.Promise<(S, G, H, J, K, L, M, N, O, P), Failure>.zip(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11)
        )
        .map { ($0, $1.0, $1.1, $1.2, $1.3, $1.4, $1.5, $1.6, $1.7, $1.8, $1.9) }
    }

    @inlinable
    public static func zip<T, S, G, H, J, K, L, M, N, O, P, Q>(
        _ p1: Publishers.Promise<T, Failure>,
        _ p2: Publishers.Promise<S, Failure>,
        _ p3: Publishers.Promise<G, Failure>,
        _ p4: Publishers.Promise<H, Failure>,
        _ p5: Publishers.Promise<J, Failure>,
        _ p6: Publishers.Promise<K, Failure>,
        _ p7: Publishers.Promise<L, Failure>,
        _ p8: Publishers.Promise<M, Failure>,
        _ p9: Publishers.Promise<N, Failure>,
        _ p10: Publishers.Promise<O, Failure>,
        _ p11: Publishers.Promise<P, Failure>,
        _ p12: Publishers.Promise<Q, Failure>
    ) -> Publishers.Promise<Output, Failure> where Output == (T, S, G, H, J, K, L, M, N, O, P, Q) {
        Publishers.Promise<(T, (S, G, H, J, K, L, M, N, O, P, Q)), Failure>.zip(
            p1,
            Publishers.Promise<(S, G, H, J, K, L, M, N, O, P, Q), Failure>.zip(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12)
        )
        .map { ($0, $1.0, $1.1, $1.2, $1.3, $1.4, $1.5, $1.6, $1.7, $1.8, $1.9, $1.10) }
    }

    public static func zip(_ promises: [Publishers.Promise<Output, Failure>]) -> Publishers.Promise<[Output], Failure> {
        switch promises.count {
        case ...0:
            return .init(value: [])
        case 1:
            return promises[0].map { [$0] }
        default:
            let result: Publishers.Promise<[Output], Failure> = promises[0].map { [$0] }

            return promises.dropFirst().reduce(result) { partial, current -> Publishers.Promise<[Output], Failure> in
                Publishers.Promise.zip(
                    partial,
                    current
                )
                .map { accumulation, next in accumulation + [next] }
            }
        }
    }

    @inlinable
    public func flatMap<T>(_ transform: @escaping (Output) -> Publishers.Promise<T, Failure>) -> Publishers.Promise<T, Failure> {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<T, Failure> {
            publisher.map(transform).switchToLatest().assertPromise("Publishers.Promise.flatMap(_:)")
        }
        return open(publisher)
    }

    @_disfavoredOverload
    @inlinable
    public func flatMap<T>(_ transform: @escaping (Output) -> Publishers.Promise<T, Never>) -> Publishers.Promise<T, Failure> {
        flatMap { transform($0).setFailureType(to: Failure.self) }
    }

    @_disfavoredOverload
    @inlinable
    public func flatMap<T, E: Error>(_ transform: @escaping (Output) -> Publishers.Promise<T, E>) -> Publishers.Promise<T, E> where Failure == Never {
        setFailureType(to: E.self).flatMap(transform)
    }

    @inlinable
    public func assertNoFailure(
        _ prefix: String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Publishers.Promise<Output, Never> {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<Output, Never> {
            publisher
                .assertNoFailure(prefix, file: file, line: line)
                .assertPromise("Publishers.Promise.assertNoFailure(_:file:line:)")
        }
        return open(publisher)
    }

    @inlinable
    public func `catch`<E: Error>(_ handler: @escaping (Failure) -> Publishers.Promise<Output, E>) -> Publishers.Promise<Output, E> {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<Output, E> {
            publisher.catch(handler).assertPromise("Publishers.Promise.catch(_:)")
        }
        return open(publisher)
    }

    @inlinable
    public func tryCatch(_ handler: @escaping (Failure) throws -> Publishers.Promise<Output, any Error>) -> Publishers.Promise<Output, any Error> {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<Output, any Error> {
            publisher.tryCatch(handler).assertPromise("Publishers.Promise.tryCatch(_:)")
        }
        return open(publisher)
    }

    @inlinable
    public func retry(_ retries: Int) -> Publishers.Promise<Output, Failure> {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<Output, Failure> {
            publisher.retry(retries).assertPromise("Publishers.Promise.retry(_:)")
        }
        return open(publisher)
    }

    @inlinable
    public func delay<S: Scheduler>(
        for interval: S.SchedulerTimeType.Stride,
        tolerance: S.SchedulerTimeType.Stride? = nil,
        scheduler: S,
        options: S.SchedulerOptions? = nil
    ) -> Publishers.Promise<Output, Failure> {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<Output, Failure> {
            publisher.delay(
                for: interval,
                tolerance: tolerance,
                scheduler: scheduler,
                options: options
            )
            .assertPromise("Publishers.Promise.delay(for:tolerance:scheduler:options:)")
        }
        return open(publisher)
    }

    @inlinable
    public func throttle<S: Scheduler>(
        for interval: S.SchedulerTimeType.Stride,
        scheduler: S
    ) -> Publishers.Promise<Output, Failure> {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<Output, Failure> {
            publisher
                .throttle(for: interval, scheduler: scheduler, latest: true)
                .assertPromise("Publishers.Promise.throttle(for:scheduler:)")
        }
        return open(publisher)
    }

    public func timeout<S: Scheduler>(
        _ interval: S.SchedulerTimeType.Stride,
        scheduler: S,
        options: S.SchedulerOptions? = nil,
        fallback: @escaping () -> Result<Output, Failure>
    ) -> Publishers.Promise<Output, Failure> {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<Output, Failure> {
            publisher
                .eraseFailureToError()
                .timeout(interval, scheduler: scheduler, options: options, customError: TimeOutFailure.init)
                .catch { error in
                    if error is TimeOutFailure {
                        return Publishers.Promise(fallback())
                    } else if let error = error as? Failure {
                        return Publishers.Promise(error: error)
                    } else {
                        os_log(
                            .error,
                            log: .publishersPromise,
                            """
                            Timeout after %{public}@ on Promise of type '%{public}@' while awaiting a value. 
                            Ensure the publisher completes within the specified interval or provide a fallback to prevent hanging states.
                            """,
                            String(describing: interval),
                            String(describing: Self.self)
                        )
                        return Publishers.Promise(outputType: Output.self, failureType: Failure.self)
                    }
                }
                .assertPromise("Publishers.Promise.timeout(_:scheduler:options:fallback:)")
        }
        return open(publisher)
    }

    @inlinable
    public func encode<Coder: TopLevelEncoder>(encoder: Coder) -> Publishers.Promise<Coder.Output, any Error> where Output: Encodable  {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<Coder.Output, any Error> {
            publisher.encode(encoder: encoder).assertPromise("Publishers.Promise.encode(encoder:)")
        }
        return open(publisher)
    }

    @inlinable
    public func decode<Item: Decodable, Coder: TopLevelDecoder>(
        type: Item.Type,
        decoder: Coder
    ) -> Publishers.Promise<Item, any Error> where Output == Coder.Input {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<Item, any Error> {
            publisher.decode(type: type, decoder: decoder).assertPromise("Publishers.Promise.decode(type:decoder:)")
        }
        return open(publisher)
    }

    @inlinable
    public func map<T>(_ keyPath: KeyPath<Output, T>) -> Publishers.Promise<T, Failure> {
        map { $0[keyPath: keyPath] }
    }

    @inlinable
    public func map<T0, T1>(
        _ keyPath0: KeyPath<Output, T0>,
        _ keyPath1: KeyPath<Output, T1>
    ) -> Publishers.Promise<(T0, T1), Failure> {
        map { ($0[keyPath: keyPath0], $0[keyPath: keyPath1]) }
    }

    @inlinable
    public func map<T0, T1, T2>(
        _ keyPath0: KeyPath<Output, T0>,
        _ keyPath1: KeyPath<Output, T1>,
        _ keyPath2: KeyPath<Output, T2>
    ) -> Publishers.Promise<(T0, T1, T2), Failure> {
        map { ($0[keyPath: keyPath0], $0[keyPath: keyPath1], $0[keyPath: keyPath2]) }
    }

    @inlinable
    public func share() -> Publishers.Promise<Output, Failure> {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<Output, Failure> {
            nonisolated(unsafe) var value: Result<Output, Failure>?
            let lock = NSLock()
            return publisher
                .share()
                .map {
                    lock.lock()
                    value = .success($0)
                    lock.unlock()
                    return $0
                }
                .mapError {
                    lock.lock()
                    value = .failure($0)
                    lock.unlock()
                    return $0
                }
                .eraseToPromise {
                    lock.lock()
                    let value = value
                    lock.unlock()
                    return value
                }
        }
        return open(publisher)
    }

    @inlinable
    public func subscribe<S: Scheduler>(
        on scheduler: S,
        options: S.SchedulerOptions? = nil
    ) -> Publishers.Promise<Output, Failure> {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<Output, Failure> {
            publisher.subscribe(on: scheduler, options: options).assertPromise("Publishers.Promise.subscribe(on:options:)")
        }
        return open(publisher)
    }

    @inlinable
    public func receive<S: Scheduler>(
        on scheduler: S,
        options: S.SchedulerOptions? = nil
    ) -> Publishers.Promise<Output, Failure> {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<Output, Failure> {
            publisher.receive(on: scheduler, options: options).assertPromise("Publishers.Promise.receive(on:options:)")
        }
        return open(publisher)
    }

    @inlinable
    public func breakpoint(
        receiveSubscription: ((any Subscription) -> Bool)? = nil,
        receiveOutput: ((Output) -> Bool)? = nil,
        receiveCompletion: ((Subscribers.Completion<Failure>) -> Bool)? = nil
    ) -> Publishers.Promise<Output, Failure> {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<Output, Failure> {
            publisher
                .breakpoint(
                    receiveSubscription: receiveSubscription,
                    receiveOutput: receiveOutput,
                    receiveCompletion: receiveCompletion
                )
                .assertPromise("Publishers.Promise.breakpoint(receiveSubscription:receiveOutput:receiveCompletion:)")
        }
        return open(publisher)
    }

    @inlinable
    public func breakpointOnError() -> Publishers.Promise<Output, Failure> {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<Output, Failure> {
            publisher.breakpointOnError().assertPromise("Publishers.Promise.breakpointOnError()")
        }
        return open(publisher)
    }

    @inlinable
    public func print(_ prefix: String = "", to stream: TextOutputStream? = nil) -> Publishers.Promise<Output, Failure> {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<Output, Failure> {
            publisher.print(prefix, to: stream).assertPromise("Publishers.Promise.print(_:to:)")
        }
        return open(publisher)
    }

    @inlinable
    public func flatMapResult<T>(_ transform: @escaping (Output) -> Result<T, Failure>) -> Publishers.Promise<T, Failure> {
        flatMap { .init(transform($0)) }
    }

    @inlinable
    public func setFailureType<E: Error>(to failureType: E.Type) -> Publishers.Promise<Output, E> where Failure == Never {
        func open(_ publisher: some Publisher<Output, Failure>) -> Publishers.Promise<Output, E> {
            publisher.setFailureType(to: failureType).assertPromise("Publishers.Promise.setFailureType(to:)")
        }
        return open(publisher)
    }

    @inlinable
    public func eraseFailureToError() -> Publishers.Promise<Output, Error> {
        mapError(identity)
    }

    /// Similar to .sink, but with correct semantic for a single-value success or a failure. Creates demand for 1
    /// value and completes after it, or on error.
    /// - Parameters:
    ///   - onSuccess: called when the promise is fulfilled successful with a value. Called only once and then
    ///                you can consider this stream finished
    ///   - onFailure: called when the promise finds error. Called only once completing the stream. It's never
    ///                called if a success was already called
    /// - Returns: the subscription that can be cancelled at any point.
    @inlinable
    public func run(onSuccess: @escaping (Output) -> Void, onFailure: @escaping (Failure) -> Void) -> AnyCancellable {
        sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    onFailure(error)
                }
            },
            receiveValue: onSuccess
        )
    }

    /// Similar to .sink, but with correct semantic for a single-value success or a failure. Creates demand for 1
    /// value and completes after it, or on error.
    /// - Parameters:
    ///   - onSuccess: called when the promise is fulfilled successful with a value. Called only once and then
    ///                you can consider this stream finished
    /// - Returns: the subscription that can be cancelled at any point.
    @inlinable
    public func run(onSuccess: @escaping (Output) -> Void) -> AnyCancellable where Failure == Never {
        run(onSuccess: onSuccess, onFailure: { _ in })
    }

    /// Similar to .sink, but with correct semantic for a single-value success or a failure. Creates demand for 1
    /// value and completes after it, or on error.
    /// - Parameters:
    ///   - onFailure: called when the promise finds error. Called only once completing the stream. It's never
    ///                called if a success was already called
    /// - Returns: the subscription that can be cancelled at any point.
    @inlinable
    public func run(onFailure: @escaping (Failure) -> Void) -> AnyCancellable where Output == Void {
        run(onSuccess: { _ in }, onFailure: onFailure)
    }

    /// Similar to .sink, but with correct semantic for a single-value success or a failure. Creates demand for 1
    /// value and completes after it, or on error.
    /// - Returns: the subscription that can be cancelled at any point.
    @inlinable
    public func run() -> AnyCancellable where Output == Void, Failure == Never {
        run(onSuccess: { _ in }, onFailure: { _ in })
    }

    /// Convert a `Publishers.Promise<Output, Error>` to `async throws -> Output`.
    ///
    /// Usage
    ///
    ///     Publishers.Promise<Int, Error>(value: 1).value()
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 8.0, *)
    @inlinable
    public func value() async throws -> Output {
        var iterator = values.makeAsyncIterator()
        guard let result = try await iterator.next() else {
            throw CancellationError()
        }
        return result
    }

    @inlinable
    public func validStatusCode() -> Publishers.Promise<Void, URLError> where Output == (data: Data, response: URLResponse), Failure == URLError {
        flatMapResult { _, response -> Result<Void, URLError> in
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(URLError(.badServerResponse))
            }

            return (200..<400) ~= httpResponse.statusCode
                ? .success(())
                : .failure(URLError(.badServerResponse))
        }
    }

    /// Case folding for Promise. Given functions that convert either errors or wrapped values into the same type FoldedValue
    /// evaluates the promise and returns Deferred<FolderValue>.
    ///
    /// - Parameters:
    ///   - onSuccess: a function that, given a wrapped value `Success`, executes an operation that returns `TargetType`,
    ///                which will be the result of this function
    ///   - onFailure: a function that, given an error `Failure`, executes an operation that returns `TargetType`,
    ///                which will be the result of this function
    /// - Returns: the value produced by applying `ifFailure` to `failure` Promise, or `ifSuccess` to `success` Promise, any of them
    ///            translated into the same `Deferred<TargetType>`.
    @inlinable
    public func fold<TargetType>(onSuccess: @escaping (Output) -> TargetType, onFailure: @escaping (Failure) -> TargetType)
    -> Publishers.Promise<TargetType, Never> {
        map(onSuccess)
            .catch { error in .init(value: onFailure(error)) }
    }

    /// Case analysis for Promise. When Promises runs, this step will evaluate possible results, run actions for them and
    /// complete with future Void when the analysis is done.
    ///
    /// - Parameters:
    ///   - ifSuccess: a function that, given a wrapped `Success`, executes an operation with no return value
    ///   - ifFailure: a function that, given an error `Failure`, executes an operation with no return value
    /// - Returns: returns a future Void, indicating that Promise ran and evaluated the two possible scenarios, success or failure.
    @inlinable
    public func analysis(ifSuccess: @escaping (Output) -> Void, ifFailure: @escaping (Failure) -> Void)
    -> Publishers.Promise<Void, Never> {
        fold(onSuccess: ifSuccess, onFailure: ifFailure)
    }

    /// If this promise results in an error, executes the provided closure passing the inner error
    ///
    /// - Parameter run: the block to execute in case this is an error
    /// - Returns: returns always `self` with no changes, for chaining purposes.
    @inlinable
    public func onError(_ run: @escaping (Failure) -> Void) -> Publishers.Promise<Output, Failure> {
        `catch` { run($0); return self }
    }
    
    private struct TimeOutFailure: Error {}
}
#endif
