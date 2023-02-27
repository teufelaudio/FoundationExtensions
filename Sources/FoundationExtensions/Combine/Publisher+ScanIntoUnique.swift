// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(Combine)
import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher where Output: Identifiable {
    /// Scans the stream and as new elements arrive, puts them into an array, and emits this array for every new individual
    /// element found.
    /// If the another element is found in the array having the same ID, you will be offered a chance to merge them into one.
    /// For that, you need to provide a function `(Output, Output) -> Output` where the left-hand side element is the
    /// previous one, already contained in the array, the right-hand side element is the appending element, and the result
    /// can be either of them unchanged, or a merge between their properties.
    ///
    /// The change, in case the element is found, will happen in place, meaning that the index will remain unchanged. The
    /// array is emitted regardless of appending or merging, even if you discard the incoming element keeping the array
    /// unchanged. If this is not desired, you have to remove duplicates by yourself.
    ///
    /// - Parameters:
    ///   - merging: a function that will receive the previous element already contained in the array as the first argument,
    ///              the appending element as the second argument, and with that you should compute the merged element between
    ///              them, or simply ignore one of them and pick the other as it is.
    /// - Returns: a scanned publisher which output is the array or upstream element, accumulated and uniqued by ID.
    public func scanIntoUniqueArray(merging: @escaping (Output, Output) -> Output) -> Publishers.Scan<Self, [Output]> {
        scan([Output]()) { array, newElement in
            var array = array
            array.append(unique: newElement, merging: merging)
            return array
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher where Output: Mergeable & Identifiable {

    /// Scans the stream and as new elements arrive, puts them into an array, and emits this array for every new individual
    /// element found.
    /// If the another element is found in the array having the same ID, you will be offered a chance to merge them into one.
    /// For that, the Mergeable `.merge` function will be used, where the left-hand side element is the previous one, already
    /// contained in the array, the right-hand side element is the appending element.
    ///
    /// The change, in case the element is found, will happen in place, meaning that the index will remain unchanged. The
    /// array is emitted regardless of appending or merging, even if you discard the incoming element keeping the array
    /// unchanged. If this is not desired, you have to remove duplicates by yourself.
    ///
    /// - Returns: a scanned publisher which output is the array or upstream element, accumulated and uniqued by ID.
    public func scanIntoUniqueArray() -> Publishers.Scan<Self, [Output]> {
        scanIntoUniqueArray(merging: Output.merge)
    }
}
#endif
