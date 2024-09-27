// Copyright © 2024 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

extension TimeInterval {
    /// Initializes a new `TimeInterval` instance from a `Duration`.
    ///
    /// - Parameter duration: The `Duration` to convert.
    /// - Returns: A new `TimeInterval` instance representing the duration in seconds.
    ///
    /// - Warning: This conversion might result in a loss of precision due to the limitations of `Double` used by `TimeInterval`.
    /// `Duration` represents time intervals as a combination of seconds and attoseconds (10^-18 seconds),
    /// whereas `TimeInterval` represents time intervals as a floating-point number of seconds (`Double`), which can only represent
    /// up to approximately 15–17 significant digits. As a result, for very large durations (e.g., values close to `Int64.max`),
    /// adding attoseconds might not increase precision significantly due to rounding.
    ///
    /// - Note: If the `Duration` contains values that exceed the precision of `Double`, the resulting `TimeInterval` may not
    /// accurately represent the smallest time increments.
    @available(iOS 16.0, macOS 13.0, *)
    public init(_ duration: Duration) {
        let seconds: Self = Self(duration.components.seconds)

        let attoseconds = duration.components.attoseconds
        let attosecondsInSeconds = attoseconds / 1_000_000_000_000_000_000 // Whole seconds from attoseconds
        let remainingAttoseconds = attoseconds % 1_000_000_000_000_000_000 // Fractional part of attoseconds

        // Convert the fractional part of attoseconds into a Double (fractional seconds)
        let fractionalSeconds = Self(remainingAttoseconds) / 1e18

        // Combine the whole seconds and fractional seconds to form the final TimeInterval
        self = seconds + Self(attosecondsInSeconds) + fractionalSeconds
    }
}
