//
//  Mergeable.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 29.05.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

/// This protocol abstracts data structures that can be reduced from 2 into 1. In Mathematics this is called
/// Magma or Groupoid (https://en.wikipedia.org/wiki/Magma_(algebra)) and several known data structures satisfy
/// this algebra structure, such as Arrays, Strings, Numbers, Booleans.
///
/// All it has to do is to provide a way of merging two elements of the same type into a third, also of the same
/// type. This is often called a binary operation.
///
/// When this binary operation is associative, a Magma is also called Semigroup (https://en.wikipedia.org/wiki/Semigroup),
/// which means that regardless of running `(a • b) • c` with left operation happening first, or `a • (b • c)` with right
/// operation happening first, the result would be the same. Every Semigroup is a Magma, but not every Magma is a Semigroup.
///
/// Semigroups that also conform to Emptyable (they have a neutral element) are also called Monoids. Booleans are monoid in
/// two ways: AND and OR. Integers are monoids in several ways (+, *, max, min, and others), Strings and Arrays are monoids
/// in concatenation.
public protocol Mergeable {
    /// Merges two elements of the same type in a third one, also of the same type.
    /// - Parameters:
    ///   - lhs: first element
    ///   - rhs: second element
    /// - Returns: the merged element
    static func merge(_ lhs: Self, _ rhs: Self) -> Self
}

extension Mergeable {
    /// Merges this element with another of the same type in a third one, also of the same type.
    /// - Parameters:
    ///   - other: second element
    /// - Returns: the merged element
    public func merge(with other: Self) -> Self {
        Self.merge(self, other)
    }
}
