//
//  Strideable+Extensions.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 31.07.19.
//  Copyright © 2019 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation
// swiftlint:disable identifier_name

extension Strideable {

    /// For this element, checks if it's within a certain range of elements, that means, if it's greater or equals to the
    /// lower-bound of the range, and also lower or equals to the higher-bound of the range.
    /// For example, `42.within(40...50)` is true, also is `42.within(40...42)`, however `42.within(30...41)` will be
    /// false, once the number is too high. Another way of doing this is by creating a range from the average number and
    /// a tolerance, for example `42 ± 10` creates a range from 32 to 52: `(32...52)`. That way you can ask things like
    /// `42.within(40 ± 2)` and this will be true because the valid range goes from 38 to 42, inclusive.
    /// - Parameter range: The range to compare the base element with. The return will be true if the base is greater or
    ///                    equals to the lower-bound of this range, and also lower or equals to the higher-bound of this
    ///                    range.
    /// - Returns: true if the base number is in the bounds of the range, false otherwise
    public func within(_ range: ClosedRange<Self>) -> Bool {
        return range.contains(self)
    }
}

/// Creates a range for an average number and a tolerance. The range will be from the average number minus the tolerance,
/// to the average number plus the tolerance: `(average - tolerance ... average + tolerance)`. That means, if the number
/// is `5` and tolerance is `2`, range will be `(3...7)`.
/// - Parameter average: the number that will be exactly in the middle of the output range
/// - Parameter tolerance: the number to be subtracted or summed to the average number, so we have our range
public func ± <T: Strideable>(_ average: T, _ tolerance: T.Stride) -> ClosedRange<T> {
    return (average.advanced(by: -abs(tolerance)) ... average.advanced(by: abs(tolerance)))
}

/// Approximately equals to another number, that is given by a range. This is a short-form of asking if the base number
/// is within some range: `base.within(range)`. It can be used together with the operator ± to create a mathematical
/// expression in order to evaluate equality of a number against other, relaxing the comparison by providing an accuracy.
/// For example:
/// `42 ≅ 41 ± 1` is expected to return true, as we want to know if 42 is within the range from 40 to 42
/// `42 ≅ 30 ± 15` is expected to return true, as we want to know if 42 is within the range from 15 to 45
/// `42 ≅ 42 ± 0` is expected to return true, as we want to know if 42 is within the range from 42 to 42
/// `42 ≅ 41.5 ± 0.5` is expected to return true, as we want to know if 42 is within the range from 41 to 42
/// `42 ≅ 40 ± 1` is expected to return *false*, as we want to know if 42 is within the range from 39 to 41 and we know
/// that 42 is greater than the higher-bound, therefore the range doesn't contain the base element.
/// - Parameter base: the number on the left-hand-side of this expression is the base number we are evaluating against
///                   certain range.
/// - Parameter range: The range to compare the base element with. The return will be true if the base is greater or
///                    equals to the lower-bound of this range, and also lower or equals to the higher-bound of this
///                    range.
public func ≅ <T: Strideable>(_ base: T, _ range: ClosedRange<T>) -> Bool {
    return base.within(range)
}
