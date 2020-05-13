//
//  Numeric+Extensions.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 11.10.18.
//  Copyright © 2018 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

// MARK: - Interpolation & Progress for Floating Points
extension BinaryFloatingPoint {

    /// Linear Interpolation between two floating-point numbers of same type
    /// (https://en.wikipedia.org/wiki/Linear_interpolation)
    /// Usage:
    /// assert(Double.linearInterpolation(minimum: 0.0, maximum: 10.0, percentage: 0.5) == 5.0)
    /// assert(Double.linearInterpolation(minimum: 1.0, maximum: 2.0, percentage: 0.5) == 1.5)
    /// assert(Double.linearInterpolation(minimum: 1.0, maximum: 3.0, percentage: 0.2) == 1.4)
    ///
    /// - Parameters:
    ///   - minimum: lower number
    ///   - maximum: greater number
    ///   - percentage: point in interpolation where the result should be, from 0.0 to 1.0
    /// - Returns: the normalized number between maximum and minimum, given the percentage progress
    public static func linearInterpolation(minimum: Self, maximum: Self, percentage: Self) -> Self {
        (percentage * (maximum - minimum)) + minimum
    }

    /// Linear Progress between two floating-point numbers of same type
    /// It's the dual of Linear Interpolation, for a value we want the percentage, not the opposite.
    /// Usage:
    /// assert(Double.linearProgress(minimum: 0.0, maximum: 10.0, current: 5.0) == 0.5)
    /// assert(Double.linearProgress(minimum: 1.0, maximum: 2.0, current: 1.5) == 0.5)
    /// assert(Double.linearProgress(minimum: 1.0, maximum: 3.0, current: 1.4) == 0.2)
    /// assert(Double.linearProgress(minimum: 1.0, maximum: 3.0, current: 3.5) == 1.0)
    /// assert(Double.linearProgress(minimum: 1.0, maximum: 3.0, current: 3.5, constrainedToValidPercentage: false) == 1.25)
    ///
    /// - Parameters:
    ///   - minimum: lower number
    ///   - maximum: greater number
    ///   - current: point in interpolation where the result should be, from minimum to maximum
    ///   - constrainedToValidPercentage: constrains the result between 0% and 100%
    /// - Returns: the percentage representing the progress that `current` value travelled from `minimum` to `maximum`
    public static func linearProgress(minimum: Self, maximum: Self, current: Self, constrainedToValidPercentage: Bool = true) -> Self {
        assert(maximum > minimum, "On function linearProgress, maximum value \(maximum) should be greater than minimum value \(minimum)")
        let value = constrainedToValidPercentage
            ? current.clamped(to: minimum...maximum)
            : current

        return (value - minimum) / (maximum - minimum)
    }

    /// Combined operation of `linearProgress` and `linearInterpolation`.
    ///
    /// First gets the progress of `current` between `minimum` and `maximum`, optionally
    /// `constrainedToValidPercentage`, then interpolates this onto the bracket defined by
    /// `lowerBound` and `upperBound`.
    /// - Parameters:
    ///   - minimum: Absolute minimum value for the progress calculation.
    ///   - maximum: Absolute maximum value for the progress calculation.
    ///   - current: Absolute current value for the progress calculation.
    ///   - constrainedToValidPercentage: Determines if percentage is clamped to `0...1`.
    ///   - lowerBound: Absolute lower bound of the interpolation bracket.
    ///   - upperBound: Absolute upper bound of the interpolation bracket.
    /// - Returns: The absolute value returned by using the calculated percentage as `current` for
    ///     `linearInterpolation`.
    public static func interpolateProgress(
        minimum: Self,
        maximum: Self,
        current: Self,
        constrainedToValidPercentage: Bool = true,
        ontoBracketWith lowerBound: Self,
        upperBound: Self) -> Self {
        let percentage = linearProgress(
            minimum: minimum,
            maximum: maximum,
            current: current,
            constrainedToValidPercentage: constrainedToValidPercentage)
        let interpolation = linearInterpolation(
            minimum: lowerBound,
            maximum: upperBound,
            percentage: percentage)
        return interpolation
    }
}

// MARK: - Interpolation & Progress for Integers
extension BinaryInteger {

    /// Linear Interpolation between two integer numbers of same type
    /// (https://en.wikipedia.org/wiki/Linear_interpolation)
    /// Usage:
    /// assert(Int.linearInterpolation(minimum: 0, maximum: 10, percentage: 0.5) == 5.0)
    /// assert(Int.linearInterpolation(minimum: 1, maximum: 2, percentage: 0.5) == 1.5)
    /// assert(Int.linearInterpolation(minimum: 1, maximum: 3, percentage: 0.2) == 1.4)
    ///
    /// - Parameters:
    ///   - minimum: lower number
    ///   - maximum: greater number
    ///   - percentage: point in interpolation where the result should be, from 0.0 to 1.0
    /// - Returns: the normalized number between maximum and minimum, given the percentage progress
    public static func linearInterpolation(minimum: Self, maximum: Self, percentage: Double) -> Double {
        Double.linearInterpolation(minimum: Double(minimum),
                                   maximum: Double(maximum),
                                   percentage: percentage)
    }

    /// Linear Progress between two integer numbers of same type
    /// It's the dual of Linear Interpolation, for a value we want the percentage, not the opposite.
    /// Usage:
    /// assert(Int.linearProgress(minimum: 0, maximum: 10, current: 5) == 0.5)
    /// assert(Int.linearProgress(minimum: 1, maximum: 2, current: 1) == 0.5)
    /// assert(Int.linearProgress(minimum: 1, maximum: 3, current: 1) == 0.333)
    /// assert(Int.linearProgress(minimum: 1, maximum: 3, current: 4) == 1.0)
    /// assert(Int.linearProgress(minimum: 1, maximum: 3, current: 6, constrainedToValidPercentage: false) == 2.0)
    ///
    /// - Parameters:
    ///   - minimum: lower number
    ///   - maximum: greater number
    ///   - current: point in interpolation where the result should be, from minimum to maximum
    ///   - constrainedToValidPercentage: constrains the result between 0% and 100%
    /// - Returns: the percentage representing the progress that `current` value travelled from `minimum` to `maximum`
    public static func linearProgress(minimum: Self, maximum: Self, current: Self, constrainedToValidPercentage: Bool = true) -> Double {
        Double.linearProgress(minimum: Double(minimum),
                              maximum: Double(maximum),
                              current: Double(current),
                              constrainedToValidPercentage: constrainedToValidPercentage)
    }
}

extension Double {
    /// Logistic Function
    /// (https://en.wikipedia.org/wiki/Logistic_function)
    /// It's a sigmoid curve (S shaped) with the equation
    /// `f(x) = L / (1 + pow(Euler, -k * (x - x0)))`
    /// - Parameters:
    ///   - `x`: value on X-axis
    ///   - `l`: the maximum value of Y-axis
    ///   - `k`: the logistic growth rate (steepness of the curve)
    ///   - `x₀`: the value of `x` when `y` is at 50% (midpoint of the curve)
    /// - Returns: the value of `y` for the given `x` in this logistic function
    public static func logistic(x: Double, L: Double, k: Double, x₀: Double) -> Double { // swiftlint:disable:this identifier_name
        L / (1.0 + pow(M_E, -k * (x - x₀)))
    }
}

extension Numeric where Self: Comparable {
    /// Constrain current number in a range. If number is lower than range, the result will be the minimum (lower bound),
    /// if the number is greater than range, the result will be the maximum (upper bound). If the number is within the
    /// range, the result will be the number.
    ///
    /// - Parameter range: Closed range, for example `(0.0 ... 100.0)`
    /// - Returns: A number within the range, that can be the original number itself or minimum/maximum in case the
    ///            original number was lower or higher than expected.
    public func clamped(to range: ClosedRange<Self>) -> Self {
        return min(max(self, range.lowerBound), range.upperBound)
    }
}
