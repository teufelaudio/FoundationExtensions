//
//  Array+Identifiable.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 29.05.20.
//  Copyright © 2018 Lautsprecher Teufel GmbH. All rights reserved.
//

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Array where Element: Identifiable {

    /// Find an element by its ID and then change it in place. The position of items won't be affected.
    /// - Parameters:
    ///   - id: the element ID to make the search in this array
    ///   - transform: a function that will give you the index of the found element, the element itself
    ///                as a mutable copy, and expects that you make the changes required in the given
    ///                object. This closure doesn't expect any return, you can simply change the element.
    ///                Any transformation is valid, including changing the ID itself to a different one.
    /// - Returns: true if element with that id was found (transform closure was called), or false in case
    ///            there's no element with that ID
    @discardableResult
    public mutating func change(id: Element.ID, transform: (Array.Index, inout Element) -> Void) -> Bool {
        guard let index = firstIndex(where: { $0.id == id }) else { return false }
        var copy = self[index]
        transform(index, &copy)
        self[index] = copy
        return true
    }

    /// Finds an element by ID and replace it with the provided instance. The position of items won't be affected.
    /// - Parameter element: the element we are willing to replace. Its ID will be used to find the index of element,
    ///                      and in that case the provided element will replace the old one in the same index.
    /// - Returns: true if element with that id was found (element was replaced), or false in case
    ///            there's no element with that ID
    @discardableResult
    public mutating func replace(_ element: Element) -> Bool {
        guard let index = firstIndex(where: { $0.id == element.id }) else { return false }
        self[index] = element
        return true
    }

    /// Finds the first element with the given ID in receiving array.
    /// - Parameter id: ID of the element to find.
    /// - Returns: Returns the first element with the given ID, or nil if an element with the given ID could
    /// not be found.
    public func first(by id: Element.ID) -> Element? {
        first(where: { $0.id == id })
    }

    /// Finds the last element with the given ID in receiving array.
    /// - Parameter id: ID of the element to find.
    /// - Returns: Returns the last element with the given ID, or nil if an element with the given ID could
    /// not be found.
    public func last(by id: Element.ID) -> Element? {
        last(where: { $0.id == id })
    }
}
