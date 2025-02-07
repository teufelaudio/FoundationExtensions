// Copyright © 2025 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(Combine)
import Combine
import OSLog

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {
    /// Promise Publisher - Unsupported Modifiers
    /// ---------------------------------------------
    /// The following modifiers are unsupported for Promise because they lead to
    /// undefined behavior, hangs, or crashes.
    ///
    /// ⚠️ Developers can technically call these modifiers since Promise is a Publisher.
    ///
    /// 🛑 Unsupported Modifiers:
    /// - scan, tryScan, filter, tryFilter, compactMap, tryCompactMap
    /// - removeDuplicates, replaceEmpty
    /// - collect, reduce, tryReduce, count, max, tryMax, min, tryMin, ignoreOutput
    /// - allSatisfy, tryAllSatisfy
    /// - drop, dropFirst, tryDrop, prefix, tryPrefix, first, tryFirst, last, tryLast, output
    /// - merge, append, prepend, switchToLatest, combineLatest
    /// - debounce, timeout(_:scheduler:options:customError:), measureInterval
    /// - multicast, buffer, makeConnectable, handleEvents
    ///
    /// ❗ Example: Calling `.filter` on an Promise can hang indefinitely if the promise resolves with a non-matching value.
    ///
    /// ➡️ Best Practice: Avoid using modifiers that does not return Promise.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public struct Promise<Output, Failure: Error>: CustomStringConvertible, CustomPlaygroundDisplayConvertible {
        @usableFromInline
        internal let publisher: any Publisher<Output, Failure>

        public init(
            _ operation: @Sendable @escaping (@Sendable @escaping (Result<Output, Failure>) -> ()) -> Cancellable
        ) {
            self.init(
                AnyPublisher.create { promise in
                    // FIXME: https://forums.swift.org/t/promise-is-non-sendable-type/68383
                    // Apple does not really care about Combine framework anymore...
                    #if swift(>=6)
                    nonisolated(unsafe) let promise = promise
                    #endif
                    return operation { result in
                        switch result {
                        case let .success(value):
                            promise.send(value)
                            promise.send(completion: .finished)
                        case let .failure(error):
                            promise.send(completion: .failure(error))
                        }
                    }
                }
            )
        }

        @inlinable
        public init(_ asyncFunc: @escaping @Sendable () async throws -> Output) where Failure == Error {
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

        @inlinable
        public init(_ asyncFunc: @escaping @Sendable () async -> Output) where Failure == Never {
            self.init { promise in
                let task = Task { @Sendable in
                    let result = await asyncFunc()
                    promise(.success(result))
                }

                return AnyCancellable { task.cancel() }
            }
        }

        @inlinable
        public init<P: Publisher>(_ publisher: P, onEmpty fallback: @Sendable @escaping () -> Result<Output, Failure>? = { nil })
        where Output == P.Output, Failure == P.Failure {
            if let erased = publisher as? Self {
                self.publisher = erased.publisher
            } else {
                self.publisher = publisher
                    .prefix(1)
                    .map { value in return { Result.success(value) } }
                    .replaceEmpty(with: { fallback() })
                    .flatMap { output in
                        switch output() {
                        case let .some(result):
                            return Future<Output, Failure> { promise in
                                promise(result)
                            }
                            .eraseToAnyPublisher()
                        case .none:
                            os_log(
                                .error,
                                log: .publishersPromise,
                                "%@",
                            """
                            Publisher of type '\(String(describing: P.self))' completed unexpectedly without publishing any value or error. \
                            No fallback value was provided, leaving the Promise in a hanging state. \
                            Ensure the Publisher emits a value or provide a fallback to avoid this issue.
                            """
                            )
                            return Empty<Output, Failure>(completeImmediately: false)
                                .eraseToAnyPublisher()
                        }
                    }
            }
        }

        @inlinable
        public init(value: Output, failureType: Failure.Type = Failure.self) {
            self.publisher = Just(value).setFailureType(to: Failure.self)
        }

        @_disfavoredOverload
        @inlinable
        public init(value: Output) where Failure == Never {
            self.init(value: value, failureType: Failure.self)
        }

        @inlinable
        public init(value: Output) {
            self.init(value: value, failureType: Failure.self)
        }

        @inlinable
        public init(outputType: Output.Type = Output.self, error: Failure) {
            self.publisher = Fail(error: error)
        }

        @inlinable
        public init(error: Failure) where Output == Void {
            self.publisher = Fail(error: error)
        }

        @inlinable
        public init(_ result: Result<Output, Failure>) {
            switch result {
            case let .success(output):
                self.init(value: output, failureType: Failure.self)
            case let .failure(error):
                self.init(outputType: Output.self, error: error)
            }
        }

        @inlinable
        public init(
            outputType: Output.Type = Output.self,
            failureType: Failure.Type = Failure.self
        ) {
            self.publisher = Empty(completeImmediately: false, outputType: outputType, failureType: failureType)
        }

        @inlinable
        public var description: String {
            "Publishers.Promise"
        }

        @inlinable
        public var playgroundDescription: Any {
            description
        }

        static func unsafe<P: Publisher>(_ publisher: P, prefix: String = "", file: StaticString = #file, line: UInt = #line) -> Self
        where P.Output == Output, P.Failure == Failure {
            self.init(
                publisher,
                onEmpty: {
                    fatalError(
                        "\(prefix)Publisher of type '\(String(describing: P.self))' completed unexpectedly without publishing any value or error.",
                        file: file,
                        line: line
                    )
                }
            )
        }
    }
}
#endif
