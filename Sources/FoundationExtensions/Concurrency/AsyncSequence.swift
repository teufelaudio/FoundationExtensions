// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import _Concurrency

extension AsyncSequence {
    
    /// Returns a new asynchronous sequence that transforms the elements of the sequence using a key path.
    ///
    /// This method works as a shortcut for the `map` function, specifically using a key path as the transform function. Each element of the sequence is transformed to the value at the specified key path of the element.
    ///
    /// - Parameter kp: A key path that specifies which property value to map from each element in the sequence.
    /// - Returns: A new asynchronous sequence that contains the transformed elements. Each element is the value at the specified key path of the corresponding element in the original sequence.
    @inlinable
    public func map<Value>(_ kp: KeyPath<Element, Value>) -> AsyncMapSequence<Self, Value> {
        map { $0[keyPath: kp] }
    }
}

// FIXME: https://github.com/swiftlang/swift/issues/57560
extension KeyPath: @unchecked Sendable {}
