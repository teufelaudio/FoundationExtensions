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
                                                         onCancel: { asyncPromise.cancel })
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
fileprivate class AsyncPromise<Success, Failure: Error> {
    private var cancellable: AnyCancellable?
    fileprivate var cancel: Void { cancellable = nil }
    fileprivate func value(from promise: Publishers.Promise<Success, Failure>) async throws -> Success {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.cancellable = promise
                .run(onSuccess: { success in continuation.resume(returning: success) },
                     onFailure: { error in continuation.resume(throwing: error) })
        }
    }
}
