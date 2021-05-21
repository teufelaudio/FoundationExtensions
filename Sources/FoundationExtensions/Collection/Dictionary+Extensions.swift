//
//  Dictionary+Extensions.swift
//  FoundationExtensions
//
//  Copyright © 2021 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

extension Dictionary where Key == String {

    /// Allows to use enum cases as a key for the subscript as long as the key of the Dictionary and the raw value of the enum
    /// is `ExpressibleByStringLiteral`
    ///
    /// Example:
    /// ```
    /// enum Key: String {
    ///     case foo
    ///     case bar
    /// }
    ///
    /// let someDict: [String: Any]
    /// var foo = someDict[Key.foo]
    public subscript<Index: RawRepresentable>(index: Index) -> Value? where Index.RawValue == String {
        get {
            return self[index.rawValue]
        }

        set {
            self[index.rawValue] = newValue
        }
    }
}
