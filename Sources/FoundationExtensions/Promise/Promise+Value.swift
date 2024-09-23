// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.Promise where Output: Sendable {
    /// Convert a `Promise<Output, Error>` to `async throws -> Output`.
    ///
    /// Usage
    ///
    ///     Publishers.Promise<Int, Error>(value: 1).value
    public var value: Output {
        get async throws {
            let asyncPromise = AsyncPromise<Output, Failure>()
            return try await withTaskCancellationHandler(
                operation: { try await asyncPromise.value(from: self) },
                onCancel: { asyncPromise.cancel() }
            )
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
fileprivate final class AsyncPromise<Success: Sendable, Failure: Error>: @unchecked Sendable {
    private var cancellable: AnyCancellable?
    private var continuation: CheckedContinuation<Success, Error>?
    private let lock = NSLock()

    fileprivate func cancel() {
        lock.lock()
        continuation?.resume(throwing: CancellationError())
        cleanUp()
        lock.unlock()
    }

    fileprivate func value(from promise: Publishers.Promise<Success, Failure>) async throws -> Success {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.lock.lock()
            self?.continuation = continuation
            self?.cancellable = promise.sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    self.lock.lock()
                    switch completion {
                    case .finished:
                        self.cancel()
                    case let .failure(error):
                        self.continuation?.resume(throwing: error)
                        self.cleanUp()
                    }
                    self.lock.unlock()
                },
                receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    self.lock.lock()
                    continuation.resume(returning: value)
                    self.cleanUp()
                    self.lock.unlock()
                }
            )
            self?.lock.unlock()
        }
    }

    private func cleanUp() {
        lock.lock()
        cancellable = nil
        continuation = nil
        lock.unlock()
    }
}
