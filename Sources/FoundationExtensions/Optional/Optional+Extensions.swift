//
//  Optional+Extensions.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 14.09.18.
//  Copyright © 2018 Lautsprecher Teufel GmbH. All rights reserved.
//

extension Optional where Wrapped: Collection {

    /// On an optional array, this property is true if the object is nil or has an empty array
    public var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

extension Optional {
    typealias Generic<A> = A?

    /// Applicative functor, given an optional transformation (a map function from Wrapped -> A, or nil),
    /// applies this transformation to the wrapped value, if there's a wrapped value and there's a wrapped function.
    /// `Optional<Int>.some(5).apply(maybeDoubleMe)` ==> `10` if maybeDoubleMe is a valid function, or `nil` if maybeDoubleMe is nil
    /// `Optional<Int>.none.apply(maybeDoubleMe)` ==> nil, regardless of maybeDoubleMe
    ///
    /// - Parameter transform: Optional transformation from current Wrapped to any other type
    /// - Returns: The function applied to the wrapped value, if both - value and function - are not nil. Otherwise nil.
    public func apply<A>(_ transform: ((Wrapped) -> A)?) -> A? {
        return zip(self, transform).map { value, function in function(value) }
    }

    /// Lifts a function that transforms the wrapped type into another type, to a function that transforms an optional element into another
    /// This function can be useful if you have several optionals of same type and want to apply the same transformation on
    /// all of them.
    /// ```
    /// let stringify = Int?.lift(String.init)
    /// stringify(1) // ==> "1"
    /// stringify(2) // ==> "2"
    /// stringify(nil) // ==> nil
    /// ```
    ///
    /// - Parameter function: a function that transforms one element type into another
    /// - Returns: it returns another function that will apply the given transformation into the wrapped element of an optional
    public static func lift<A>(_ function: @escaping (Wrapped) -> A) -> (Optional) -> A? {
        return { $0.map(function) }
    }

    /// Given a nested optional, flattenize it into a single level optional
    /// `Optional<Optional<Int>>.some(1).flatten() // Optional<Int>.some(1)`
    /// The same as `flatMap({ $0 })` (a flatMap where the map doesn't do any transformation)
    ///
    /// - Returns: Flat optional out of the nested one
    public func flatten<A>() -> A? where Wrapped == A? {
        return flatMap(identity)
    }

    /// Given a predicate that tests possible wrapped value, returns nil if there is no wrapped value already, or if the
    /// current wrapped value is false for the predicate. It returns the wrapped value unchanged in case it's true for the
    /// predicate
    ///
    /// - Parameter predicate: a predicate that tests the possible wrapped type
    /// - Returns: the wrapped value unchanged in case it has a value that is positive for the predicate. Or nil.
    public func filter(_ predicate: (Wrapped) -> Bool) -> Optional {
        return flatMap { element in
            return predicate(element) ? .some(element) : .none
        }
    }

    /// Transforms the Optional into a Result type. The error must be provided for case the Optional doesn't have wrapped value.
    ///
    /// - Parameter errorGeneration: autoclosure that creates an error to be the right-hand side of a Result in case there's no value
    /// - Returns: Result having either the wrapped value, or the evaluated parameter as error case
    public func toResult<Failure: Error>(orError errorGeneration: @autoclosure () -> Failure) -> Result<Wrapped, Failure> {
        return fold(onSome: { .success($0) },
                    onNone: { .failure(errorGeneration()) })
    }
}
