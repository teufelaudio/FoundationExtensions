// Copyright © 2021 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(Combine)
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Subscribers.Completion {
    /// Instead of Switch/Case over Completion, it's easier to transform it into Result and use all Result operators.
    /// Example:
    /// ```swift
    /// .sink(
    ///     receiveCompletion: { completion in
    ///         completion.asResult.onError(handleError)
    ///         // or completion.asResult.analysis(ifSuccess: { }, ifFailure: { error in })
    ///     },
    ///     receiveValue: { value in
    ///         print(value)
    ///     }
    /// )
    /// ```
    /// The value in the Result is always Void, because it doesn't get the outputs from the publisher, only the signal of successful completion.
    /// For the values received, please use the receiveValue closure, or if it's a Promise (that is guaranteed to always emit either a value or
    /// an error), then use `Publishers.Promise.run(onSuccess:onFailure)`.
    public var asResult: Result<Void, Failure> {
        switch self {
        case .finished: return .success()
        case let .failure(error): return .failure(error)
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
    /// A simplified version of sink that allows to catch errors but ignore successful completions.
    /// Instead of:
    /// ```swift
    /// .sink(
    ///     receiveCompletion: { completion in
    ///         guard let .failure(error) = completion else { return }
    ///         handleError(error)
    ///     },
    ///     receiveValue: handleNewValue
    /// )
    /// ```
    /// you can do:
    /// ```swift
    /// .sink(
    ///     receiveError: handleError,
    ///     receiveValue: handleNewValue
    /// )
    /// ```
    public func sink(receiveError: @escaping (Failure) -> Void, receiveValue: @escaping (Output) -> Void) -> AnyCancellable {
        sink(
            receiveCompletion: { completion in
                completion.asResult.onError(receiveError)
            },
            receiveValue: receiveValue
        )
    }
}
#endif
