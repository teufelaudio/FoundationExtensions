//
//  BinaryFloatingPoint+Extensions.swift
//  FoundationExtensions
//
//  Created by Luis Reisewitz on 17.01.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

// MARK: - Sign Management
extension BinaryFloatingPoint {
    /// Returns the negated version of itself, meaning the sign is flipped.
    public var negated: Self {
        var copy = self
        copy.negate()
        return copy
    }

    public func useSign(from value: Self) -> Self {
        var copy = self
        // Flips sign if the sign is currently not the same. Works, no matter
        // what combination of signs both parties have.
        if value.sign != copy.sign {
            copy *= -1
        }
        return copy
    }
}

// MARK: - Random Float Generation
extension BinaryFloatingPoint where Self.RawSignificand: FixedWidthInteger {
    /// Returns a random element between (-1 * .greatestFiniteMagnitude) and .greatestFiniteMagnitude.
    /// Due to the way random numbers are generated, some numbers might occur more frequently than others.
    /// This is equivalent to calling `random(using:` and passing in the default system generator.
    public static func random() -> Self {
        var generator = SystemRandomNumberGenerator()
        return random(using: &generator)
    }

    /// Returns a random element between (-1 * .greatestFiniteMagnitude) and .greatestFiniteMagnitude.
    /// Due to the way random numbers are generated, some numbers might occur more frequently than others.
    /// - Parameter generator: The random number generator to use when creating
    ///   the new random value.
    public static func random<T>(using generator: inout T) -> Self where T: RandomNumberGenerator {
        let originalNumber = random(in: -1...1, using: &generator)
            print("original \(originalNumber)")
         return originalNumber * .greatestFiniteMagnitude
    }
}
