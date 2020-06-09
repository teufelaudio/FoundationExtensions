//
//  Array+Extensions.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 21.08.18.
//  Copyright © 2018 Lautsprecher Teufel GmbH. All rights reserved.
//

extension Array {
    /// Convenient way to call static functions without having to provide the generic type
    typealias Generic<T> = [T]

    /// Given 2 arrays, return the cartesian product of them.
    /// `cartesian([1, 3, 5], ["a", "b"])` ==> `[(1, "a"), (1, "b"), (3, "a"), (3, "b"), (5, "a"), (5, "b")]`
    /// Cartesian product combines all from the left with all from the right, so it's different from `zip` that
    /// only matches same indexes
    ///
    /// - Parameters:
    ///   - first: Left-hand side of each resulting tuple
    ///   - second: Right-hand side of each resulting tuple
    /// - Returns: Array of tuples combining all elements from the left array with all elements of right array
    public static func cartesian<A1, A2>(_ first: [A1], _ second: [A2]) -> [(A1, A2)] where Element == (A1, A2) {
        return first.reduce([(A1, A2)]()) { externalPrevious, firstElement in
            externalPrevious + second.reduce([(A1, A2)]()) { internalPrevious, secondElement in
                internalPrevious + [(firstElement, secondElement)]
            }
        }
    }

    /// Applicative functor, given an array of transformations (several map functions from Element -> A),
    /// applies all these transformations to all elements of original array.
    /// `[5, 7].apply([doubleMe, negativeMe])` ==> `[10, -5, 14, -7]`
    ///
    /// - Parameter transform: Array of transformations from current Element to a same element type A
    /// - Returns: Cartesian product of all transformations applied to each element in the original array
    public func apply<A>(_ transform: [(Element) -> A]) -> [A] {
        return Generic
            .cartesian(self, transform)
            .map { value, function in function(value) }
    }

    /// Lifts a function that transforms one element into another type, to a function that transforms an array into another
    /// This function can be useful if you have several arrays of same type and want to apply the same transformation on
    /// all of them.
    /// ```
    /// let stringify = [Int].lift(String.init)
    /// stringify([1, 2]) // ==> ["1", "2"]
    /// stringify([3, 4]) // ==> ["3", "4"]
    /// ```
    ///
    /// - Parameter function: a function that transforms one element type into another
    /// - Returns: it returns another function that will apply the given transformation into all elements of an array
    public static func lift<A>(_ function: @escaping (Element) -> A) -> (Array) -> [A] {
        return { $0.map(function) }
    }

    /// Given a nested array, flattenize it into a single level array
    /// `[[1, 2], [3, 4, 5]].flatten() // [1, 2, 3, 4, 5]`
    /// The same as `flatMap({ $0 })` (a flatMap where the map doesn't do any transformation)
    ///
    /// - Returns: Flat array out of the nested one
    public func flatten<A>() -> [A] where Element == [A] {
        return flatMap(identity)
    }

    /// When we have an array of functions (A) -> B, we can use `call` with an array of `A` to apply the transformation
    /// to all elements of it. It's similar to `apply`, but works in the other direction, this time `self` contains the
    /// transformations and the parameter contains the values. But the expected result is the same.
    /// `[doubleMe, negativeMe].call([5, 7])` ==> `[10, 14, -5, -7]`
    ///
    /// - Parameter value: an array of values A to be transformed
    /// - Returns: an array of values B, transformed from each element of A using each function on self (cartesian product)
    public func call<A, B>(_ value: [A]) -> [B] where Element == (A) -> B {
        return Generic
            .cartesian(self, value)
            .map { function, value in function(value) }
    }
}
