//
//  ResultType+Sequence.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 30.11.18.
//  Copyright © 2018 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

extension ResultType where Success: Sequence {
    /// For this Result that may wrap a sequence of elements, given a function that goes from Value.Element (element type
    /// held by this Sequence) to ElementTransformed, transforms this `Result<[Element], Error>` into
    /// `Result<[ElementTransformed], Error>`. Because the transformation can throw errors, result might
    /// be a wrapped error that happened during the mapping process.
    ///
    /// - Parameter transform: a function that transforms Value.Element to ElementTransformed, a failable operation
    /// - Returns: a new container having a wrapped value [ElementTransformed] (array, regardless of input Collection type),
    ///            or an error from the previous result container
    public func flatMap<ElementTransformed>(_ transform: (Success.Element) -> Result<ElementTransformed, Failure>)
        -> Result<[ElementTransformed], Failure> {
        return fold(onSuccess: { items in
            // Because the operation flips the container ( `[Result<A, Failure>]` -> `Result<[B], Failure>` ), we can only transform until
            // the first error and fail early. That means, if in the given array the transformation would fail for several elements, the
            // final result will be the first error found, and we ignore the rest. This loss of information is acceptable and expected
            // because flipping container keep the array side only on .success side, but keep the Error side as a single-element entity.
            // As an alternative, return could be `Result<[B], [Failure]>` but this would hurt the composition.
            return items.reduce(Result<[ElementTransformed], Failure>.success([]), { accumulator, itemA in
                switch accumulator {
                case .failure:
                    // The previous situation is already an error, don't even try to transform the other items
                    return accumulator

                case .success(var resultArray):
                    // So far we found only values, let's keep transforming elements
                    let transformationResult = transform(itemA)

                    switch transformationResult {
                    case .success(let itemB):
                        // Transformation of current element succeeded, append to accumulator
                        resultArray.append(itemB)
                        return .success(resultArray)
                    case .failure(let error):
                        // This element failed to transform, from now on the accumulator will be an error and no
                        // new elements will be transformed.
                        return .failure(error)
                    }
                }
            })
        }, onFailure: { error in
            // The whole container was already an error, nothing to do
            return .failure(error)
        })
    }
}
