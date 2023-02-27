// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

extension Collection {

    /// Traverse is a way to apply a transformation that maps each element of a collection into a new element that is
    /// contained in some other container type. But the result of this function flips the containers, making the collection
    /// to be inside in the final result, and not outside as we would expect in a regular map.
    ///
    /// For this case the transformation maps to elements contained in an Array, so it will behave exactly as a regular map.
    /// Still, we need this function for composition.
    /// `[2, 1, 3].traverse { Array(repeating: "\($0)", count: $0) }` // ==> `[["2", "2"], ["1"], ["3", "3", "3"]]`
    ///
    /// - Parameter transform: a transformation from the element type of this array, into an Array of any other type
    /// - Returns: A nested array of the transformed elements. Because we are flipping Arrays with Arrays, this is equivalent
    ///            to mapping.
    public func traverse<A>(_ transform: (Element) -> [A]) -> [[A]] {
        return map { transform($0) }
    }

    /// Traverse is a way to apply a transformation that maps each element of a collection into a new element that is
    /// contained in some other container type. But the result of this function flips the containers, making the collection
    /// to be inside in the final result, and not outside as we would expect in a regular map.
    ///
    /// For this case the transformation maps to nullable elements (container Optional), and if one of them returns nil
    /// instead of some wrapped value, then the full result will be nil and other eventual successful transformations will
    /// be discarded.
    /// `["2", "1", "3"].traverse { NumberFormatter().number(from: $0)?.intValue }` // ==> `[2, 1, 3]`
    /// `["2", "1", "3", "Oops"].traverse { NumberFormatter().number(from: $0)?.intValue }` // ==> `nil`
    ///
    /// - Parameter transform: a transformation from the element type of this array, into an Optional of any other type
    /// - Returns: an Optional Array that will have elements if all original elements could be transformed, or everything
    ///            will be nil if at least one of the elements derived from the transformation fails into nil.
    public func traverse<A>(_ transform: (Element) -> A?) -> [A]? {
        return reduce([A]?.some([])) { previous, element in
            guard var accumulator = previous,
                let transformed = transform(element) else { return nil }

            accumulator.append(transformed)
            return accumulator
        }
    }

    /// Traverse is a way to apply a transformation that maps each element of a collection into a new element that is
    /// contained in some other container type. But the result of this function flips the containers, making the collection
    /// to be inside in the final result, and not outside as we would expect in a regular map.
    ///
    /// For this case the transformation maps to elements contained in a Result container, and if one of them returns Error
    /// instead of some wrapped value, then the full result will be Error and other eventual successful transformations will
    /// be discarded.
    /// ```
    /// ["2", "1", "3"].traverse {
    ///     (NumberFormatter().number(from: $0)?.intValue).toResult(orError: AnyError())
    /// } // ==> .success([2, 1, 3])
    /// ```
    ///
    /// ```
    /// ["2", "1", "3", "Oops"].traverse {
    ///     (NumberFormatter().number(from: $0)?.intValue).toResult(orError: AnyError())
    /// } // ==> .failure(AnyError())
    /// ```
    ///
    /// - Parameter transform: a transformation from the element type of this array, into a Result of any other type
    /// - Returns: a Result containing an Array that will have elements if all original elements could be transformed, or
    ///            everything will be Error if at least one of the elements derived from the transformation fails into error.
    public func traverse<A, Failure>(_ transform: (Element) -> Result<A, Failure>) -> Result<[A], Failure> {
        return reduce(Result.success([])) { previous, element in
            switch previous {
            case var .success(accumulator):
                switch transform(element) {
                case let .success(transformed):
                    accumulator.append(transformed)
                    return .success(accumulator)
                case let .failure(error):
                    return .failure(error)
                }
            case .failure:
                return previous
            }
        }
    }

    public func traverse<Environment, A>(_ transform: @escaping (Element) -> Reader<Environment, A>) -> Reader<Environment, [A]> {
        Reader { env in
            self.map { value in
                transform(value).inject(env)
            }
        }
    }
}

#if canImport(Combine)
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Collection {
    /// Traverse is a way to apply a transformation that maps each element of a collection into a new element that is
    /// contained in some other container type. But the result of this function flips the containers, making the collection
    /// to be inside in the final result, and not outside as we would expect in a regular map.
    ///
    /// For this case the transformation maps to elements contained into a Publisher container, and if one of them completes with Error,
    /// then the full publisher will fail and other eventual successful transformations will be discarded. Otherwise, the collected array
    /// will be published as zipped elements (indexed events), not combine latest, until the subscription eventually completes with success.
    ///
    /// - Parameter transform: a transformation from the element type of this array, into a Publisher of any other type
    /// - Returns: A publisher that will either give the outputs
    public func traverse<P: Publisher>(_ transform: (Element) -> P) -> AnyPublisher<[P.Output], P.Failure> {
        AnyPublisher.zip(map(transform))
    }
}
#endif
