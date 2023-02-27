#if canImport(Combine)
import Combine
import Foundation

extension Publisher {
    /// Erases `Failure` type to `Error`.
    ///
    ///     Just(1) // Just<Int>
    ///         .eraseFailureToError() // Publishers.MapError<Just<Int>, Error>
    ///
    ///     Empty(outputType: Int.self,
    ///           failureType: DecodingError.self) // Empty<Int, DecodingError>
    ///     .eraseFailureToError() // Publishers.MapError<Empty<Int, DecodingError>, Error>
    ///
    /// - Returns: An ``Publishers.MapError`` wrapping this publisher.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func eraseFailureToError() -> Publishers.MapError<Self, Error> {
        mapError(identity)
    }
}
#endif
