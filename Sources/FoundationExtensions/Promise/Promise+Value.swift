// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.Promise {
    /// Convert a `Promise<Output, Error>` to `async throws -> Output`.
    ///
    /// Usage
    ///
    ///     Publishers.Promise<Int, Error>(value: 1).value
    public var value: Output {
        get async throws {
            let asyncPromise = AsyncPromise<Output, Failure>()
            return try await withTaskCancellationHandler(operation: { try await asyncPromise.value(from: self) },
                                                         onCancel: { asyncPromise.cancel() })
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
fileprivate class AsyncPromise<Success, Failure: Error> {
    private var cancellable: AnyCancellable?
    private var continuation: CheckedContinuation<Success, Error>?

    fileprivate func cancel() {
        continuation?.resume(throwing: CancellationError())
        cleanUp()
    }

    fileprivate func value(from promise: Publishers.Promise<Success, Failure>) async throws -> Success {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            self.cancellable = promise.sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    switch completion {
                    case .finished:
                        self.cancel()
                    case let .failure(error):
                        self.continuation?.resume(throwing: error)
                        self.cleanUp()
                    }
                },
                receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    self.continuation?.resume(returning: value)
                    self.cleanUp()
                }
            )
        }
    }

    private func cleanUp() {
        cancellable = nil
        continuation = nil
    }
}
