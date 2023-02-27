// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(Combine)
import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension PromiseType {
    /// Similar to .sink, but with correct semantic for a single-value success or a failure. Creates demand for 1
    /// value and completes after it, or on error.
    /// - Parameters:
    ///   - onSuccess: called when the promise is fulfilled successful with a value. Called only once and then
    ///                you can consider this stream finished
    ///   - onFailure: called when the promise finds error. Called only once completing the stream. It's never
    ///                called if a success was already called
    /// - Returns: the subscription that can be cancelled at any point.
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
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension PromiseType where Failure == Never {
    /// Similar to .sink, but with correct semantic for a single-value success or a failure. Creates demand for 1
    /// value and completes after it, or on error.
    /// - Parameters:
    ///   - onSuccess: called when the promise is fulfilled successful with a value. Called only once and then
    ///                you can consider this stream finished
    /// - Returns: the subscription that can be cancelled at any point.
    public func run(onSuccess: @escaping (Output) -> Void) -> AnyCancellable {
        run(onSuccess: onSuccess, onFailure: { _ in })
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension PromiseType where Success == Void {
    /// Similar to .sink, but with correct semantic for a single-value success or a failure. Creates demand for 1
    /// value and completes after it, or on error.
    /// - Parameters:
    ///   - onFailure: called when the promise finds error. Called only once completing the stream. It's never
    ///                called if a success was already called
    /// - Returns: the subscription that can be cancelled at any point.
    public func run(onFailure: @escaping (Failure) -> Void) -> AnyCancellable {
        run(onSuccess: { _ in }, onFailure: onFailure)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension PromiseType where Success == Void, Failure == Never {
    /// Similar to .sink, but with correct semantic for a single-value success or a failure. Creates demand for 1
    /// value and completes after it, or on error.
    /// - Returns: the subscription that can be cancelled at any point.
    public func run() -> AnyCancellable {
        run(onSuccess: { _ in }, onFailure: { _ in })
    }
}
#endif
