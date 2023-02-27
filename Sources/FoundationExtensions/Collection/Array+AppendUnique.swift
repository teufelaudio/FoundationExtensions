// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Array where Element: Identifiable {

    /// Append an identifiable element as long as its not yet in the array, comparing by its ID.
    /// If the another element is found in the array having the same ID, you will be offered a chance to merge them into one.
    /// For that, you need to provide a function `(Element, Element) -> Element` where the left-hand side element is the
    /// previous one, already contained in the array, the right-hand side element is the appending element, and the result
    /// can be either of them unchanged, or a merge between their properties.
    ///
    /// The change, in case the element is found, will happen in place, meaning that the index will remain unchanged. This
    /// function is not thread-safe.
    ///
    /// - Parameters:
    ///   - appendingElement: the element you want to append to this array
    ///   - merging: a function that will receive the previous element already contained in the array as the first argument,
    ///              the appending element as the second argument, and with that you should compute the merged element between
    ///              them, or simply ignore one of them and pick the other as it is.
    public mutating func append(unique appendingElement: Element, merging: (Element, Element) -> Element) {
        if let dupeIndex = firstIndex(where: { $0.id == appendingElement.id }) {
            self[dupeIndex] = merging(self[dupeIndex], appendingElement)
        } else {
            self.append(appendingElement)
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Array where Element: Mergeable & Identifiable {

    /// Append an identifiable element as long as its not yet in the array, comparing by its ID.
    /// If the another element is found in the array having the same ID, you will be offered a chance to merge them into one.
    /// For that, the Mergeable `.merge` function will be used, where the left-hand side element is the previous one, already
    /// contained in the array, the right-hand side element is the appending element.
    ///
    /// The change, in case the element is found, will happen in place, meaning that the index will remain unchanged. This
    /// function is not thread-safe.
    ///
    /// - Parameters:
    ///   - appendingElement: the element you want to append to this array
    public mutating func append(unique appendingElement: Element) {
        append(unique: appendingElement, merging: Element.merge)
    }
}
