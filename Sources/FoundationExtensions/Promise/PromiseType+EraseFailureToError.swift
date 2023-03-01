// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(Combine)
import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension PromiseType {
    /// Erases `Failure` type to `Error`.
    ///
    ///     Publishers.Promise<Int, Never>(value: 1) // Publishers.Promise<Int, Never>
    ///         .eraseFailureToError() // Publishers.Promise<Publishers.Promise<Int, Never>.Output, Error>
    ///
    /// - Returns: An ``Publishers.Promise`` wrapping this promise.
    public func eraseFailureToError() -> Publishers.Promise<Output, Error> {
        mapError(identity)
    }
}
#endif
