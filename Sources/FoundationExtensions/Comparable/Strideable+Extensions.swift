// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

// swiftlint:disable identifier_name

/// Creates a range for an average number and a tolerance. The range will be from the average number minus the tolerance,
/// to the average number plus the tolerance: `(average - tolerance ... average + tolerance)`. That means, if the number
/// is `5` and tolerance is `2`, range will be `(3...7)`.
/// - Parameter average: the number that will be exactly in the middle of the output range
/// - Parameter tolerance: the number to be subtracted or summed to the average number, so we have our range
public func ± <T: Strideable>(_ average: T, _ tolerance: T.Stride) -> ClosedRange<T> {
    return (average.advanced(by: -abs(tolerance)) ... average.advanced(by: abs(tolerance)))
}
