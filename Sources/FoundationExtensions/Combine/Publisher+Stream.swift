// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 15.0, watchOS 6.0, *)
extension Publisher where Failure == Error {
    /// Apple's `.values` implementation doesn't throw `Error`. Therefore, please use
    /// `.stream` computed property over `.values`.
    public var stream: AsyncThrowingStream<Output, Failure> {
        return CombineAsyncStream(self).eraseToThrowingStream()
    }
}

@available(macOS 12.0, iOS 13.0, tvOS 15.0, watchOS 8.0, *)
extension Publisher where Failure == Never {
    public var stream: AsyncStream<Output> {
        if #available(iOS 15.0, *) {
            return values.eraseToStream()
        } else {
            return CombineAsyncStream(self).eraseToStream()
        }
    }
}

// MARK: - Helpers
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
fileprivate class CombineAsyncStream<Upstream: Publisher>: AsyncSequence {
    typealias Element = Upstream.Output
    typealias AsyncIterator = CombineAsyncStream<Upstream>

    private var stream: AsyncThrowingStream<Element, Error>
    private var cancellable: AnyCancellable?
    private lazy var iterator = stream.makeAsyncIterator()

    fileprivate init(_ upstream: Upstream) {
        stream = .init { _ in }
        cancellable = nil
        stream = .init { continuation in
            continuation.onTermination = { [weak self] _ in
                self?.cancellable?.cancel()
            }

            cancellable = upstream
                .handleEvents(
                    receiveCancel: { [weak self] in
                        continuation.finish(throwing: nil)
                        self?.cancellable = nil
                    }
                )
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        continuation.finish(throwing: error)
                    case .finished:
                        continuation.finish(throwing: nil)
                    }
                    self?.cancellable = nil
                }, receiveValue: { value in
                    continuation.yield(value)
                })
        }    }

    fileprivate func makeAsyncIterator() -> Self {
        return self
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension CombineAsyncStream: AsyncIteratorProtocol {
    fileprivate func next() async throws -> Upstream.Output? {
        return try await iterator.next()
    }
}

// MARK: Below extensions copied from https://github.com/pointfreeco/swift-dependencies v0.2.0
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension AsyncThrowingStream where Failure == Error {
    /// Produces an `AsyncThrowingStream` from an `AsyncSequence` by consuming the sequence till it
    /// terminates, rethrowing any failure.
    ///
    /// - Parameter sequence: An async sequence.
    fileprivate init<S: AsyncSequence>(_ sequence: S) where S.Element == Element {
        var iterator: S.AsyncIterator?
        self.init {
            if iterator == nil {
                iterator = sequence.makeAsyncIterator()
            }
            return try await iterator?.next()
        }
    }

    /// Constructs and returns a stream along with its backing continuation.
    ///
    /// This is handy for immediately escaping the continuation from an async stream, which typically
    /// requires multiple steps:
    ///
    /// ```swift
    /// var _continuation: AsyncThrowingStream<Int, Error>.Continuation!
    /// let stream = AsyncThrowingStream<Int, Error> { continuation = $0 }
    /// let continuation = _continuation!
    ///
    /// // vs.
    ///
    /// let (stream, continuation) = AsyncThrowingStream<Int, Error>.streamWithContinuation()
    /// ```
    ///
    /// This tool is usually used for tests where we need to supply an async sequence to a dependency
    /// endpoint and get access to its continuation so that we can emulate the dependency emitting
    /// data. For example, suppose you have a dependency exposing an async sequence for listening to
    /// notifications. To test this you can use `streamWithContinuation`:
    ///
    /// ```swift
    /// func testScreenshots() {
    ///   let screenshots = AsyncThrowingStream<Void>.streamWithContinuation()
    ///
    ///   let model = withDependencies {
    ///     $0.screenshots = { screenshots.stream }
    ///   } operation: {
    ///     FeatureModel()
    ///   }
    ///
    ///   XCTAssertEqual(model.screenshotCount, 0)
    ///   screenshots.continuation.yield()  // Simulate a screenshot being taken.
    ///   XCTAssertEqual(model.screenshotCount, 1)
    /// }
    /// ```
    ///
    /// > Warning: ⚠️ `AsyncStream` does not support multiple subscribers, therefore you can only use
    /// > this helper to test features that do not subscribe multiple times to the dependency
    /// > endpoint.
    ///
    /// - Parameters:
    ///   - elementType: The type of element the `AsyncThrowingStream` produces.
    ///   - limit: A Continuation.BufferingPolicy value to set the stream’s buffering behavior. By
    ///     default, the stream buffers an unlimited number of elements. You can also set the policy
    ///     to buffer a specified number of oldest or newest elements.
    /// - Returns: An `AsyncThrowingStream`.
    fileprivate static func streamWithContinuation(
        _ elementType: Element.Type = Element.self,
        bufferingPolicy limit: Continuation.BufferingPolicy = .unbounded
    ) -> (stream: Self, continuation: Continuation) {
        var continuation: Continuation!
        return (Self(elementType, bufferingPolicy: limit) { continuation = $0 }, continuation)
    }

    /// An `AsyncThrowingStream` that never emits and never completes unless cancelled.
    fileprivate static var never: Self {
        Self { _ in }
    }

    /// An `AsyncThrowingStream` that completes immediately.
    ///
    /// - Parameter error: An optional error the stream completes with.
    fileprivate static func finished(throwing error: Failure? = nil) -> Self {
        Self { $0.finish(throwing: error) }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension AsyncSequence {
    /// Erases this async sequence to an async throwing stream that produces elements till this
    /// sequence terminates, rethrowing any error on failure.
    fileprivate func eraseToThrowingStream() -> AsyncThrowingStream<Element, Error> {
        AsyncThrowingStream(self)
    }
}

// Below extension copied from https://github.com/pointfreeco/swift-dependencies v0.2.0
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension AsyncStream {
    /// Produces an `AsyncStream` from an `AsyncSequence` by consuming the sequence till it
    /// terminates, ignoring any failure.
    ///
    /// Useful as a kind of type eraser for live `AsyncSequence`-based dependencies.
    ///
    /// For example, your feature may want to subscribe to screenshot notifications. You can model
    /// this as a dependency client that returns an `AsyncStream`:
    ///
    /// ```swift
    /// struct ScreenshotsClient {
    ///   var screenshots: () -> AsyncStream<Void>
    ///   func callAsFunction() -> AsyncStream<Void> { self.screenshots() }
    /// }
    /// ```
    ///
    /// The "live" implementation of the dependency can supply a stream by erasing the appropriate
    /// `NotificationCenter.Notifications` async sequence:
    ///
    /// ```swift
    /// extension ScreenshotsClient {
    ///   static let live = Self(
    ///     screenshots: {
    ///       AsyncStream(
    ///         NotificationCenter.default
    ///           .notifications(named: UIApplication.userDidTakeScreenshotNotification)
    ///           .map { _ in }
    ///       )
    ///     }
    ///   )
    /// }
    /// ```
    ///
    /// While your tests can use `AsyncStream.streamWithContinuation` to spin up a controllable stream
    /// for tests:
    ///
    /// ```swift
    /// func testScreenshots() {
    ///   let screenshots = AsyncStream<Void>.streamWithContinuation()
    ///
    ///   let model = withDependencies {
    ///     $0.screenshots = { screenshots.stream }
    ///   } operation: {
    ///     FeatureModel()
    ///   }
    ///
    ///   XCTAssertEqual(model.screenshotCount, 0)
    ///   screenshots.continuation.yield()  // Simulate a screenshot being taken.
    ///   XCTAssertEqual(model.screenshotCount, 1)
    /// }
    /// ```
    ///
    /// - Parameter sequence: An async sequence.
    fileprivate init<S: AsyncSequence>(_ sequence: S) where S.Element == Element {
        var iterator: S.AsyncIterator?
        self.init {
            if iterator == nil {
                iterator = sequence.makeAsyncIterator()
            }
            return try? await iterator?.next()
        }
    }

    /// Constructs and returns a stream along with its backing continuation.
    ///
    /// This is handy for immediately escaping the continuation from an async stream, which typically
    /// requires multiple steps:
    ///
    /// ```swift
    /// var _continuation: AsyncStream<Int>.Continuation!
    /// let stream = AsyncStream<Int> { continuation = $0 }
    /// let continuation = _continuation!
    ///
    /// // vs.
    ///
    /// let (stream, continuation) = AsyncStream<Int>.streamWithContinuation()
    /// ```
    ///
    /// This tool is usually used for tests where we need to supply an async sequence to a dependency
    /// endpoint and get access to its continuation so that we can emulate the dependency emitting
    /// data. For example, suppose you have a dependency exposing an async sequence for listening to
    /// notifications. To test this you can use `streamWithContinuation`:
    ///
    /// ```swift
    /// func testScreenshots() {
    ///   let screenshots = AsyncStream<Void>.streamWithContinuation()
    ///
    ///   let model = withDependencies {
    ///     $0.screenshots = { screenshots.stream }
    ///   } operation: {
    ///     FeatureModel()
    ///   }
    ///
    ///   XCTAssertEqual(model.screenshotCount, 0)
    ///   screenshots.continuation.yield()  // Simulate a screenshot being taken.
    ///   XCTAssertEqual(model.screenshotCount, 1)
    /// }
    /// ```
    ///
    /// > Warning: ⚠️ `AsyncStream` does not support multiple subscribers, therefore you can only use
    /// > this helper to test features that do not subscribe multiple times to the dependency
    /// > endpoint.
    ///
    /// - Parameters:
    ///   - elementType: The type of element the `AsyncStream` produces.
    ///   - limit: A Continuation.BufferingPolicy value to set the stream’s buffering behavior. By
    ///     default, the stream buffers an unlimited number of elements. You can also set the policy
    ///     to buffer a specified number of oldest or newest elements.
    /// - Returns: An `AsyncStream`.
    fileprivate static func streamWithContinuation(
        _ elementType: Element.Type = Element.self,
        bufferingPolicy limit: Continuation.BufferingPolicy = .unbounded
    ) -> (stream: Self, continuation: Continuation) {
        var continuation: Continuation!
        return (Self(elementType, bufferingPolicy: limit) { continuation = $0 }, continuation)
    }

    /// An `AsyncStream` that never emits and never completes unless cancelled.
    fileprivate static var never: Self {
        Self { _ in }
    }

    /// An `AsyncStream` that never emits and completes immediately.
    fileprivate static var finished: Self {
        Self { $0.finish() }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension AsyncSequence {
    /// Erases this async sequence to an async stream that produces elements till this sequence
    /// terminates (or fails).
    fileprivate func eraseToStream() -> AsyncStream<Element> {
        AsyncStream(self)
    }
}
