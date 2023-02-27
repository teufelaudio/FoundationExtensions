// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

public func identity<A>(_ a: A) -> A {
    return a
}

public func identity<A, B>(_ a: A, _ b: B) -> (A, B) {
    return (a, b)
}

public func absurd<A>(_ never: Never) -> A { }

public func curry<A, B, C>(_ fn: @escaping (A, B) -> C) -> ((A) -> ((B) -> C)) {
    return { a in { b in fn(a, b) } }
}

public func uncurry<A, B, C>(_ fn: @escaping (A) -> ((B) -> C)) -> ((A, B) -> C) {
    return { (a, b) in fn(a)(b) }
}

public func flip<A, B, C>(_ fn: @escaping (A, B) -> C) -> ((B, A) -> C) {
    return { b, a in fn(a, b) }
}

public func run<A>(_ fn: @escaping () -> A) -> A {
    return fn()
}

public func partialApply<A, B, C>(_ fn: @escaping (A, B) -> C, _ a: A) -> ((B) -> C) {
    return curry(fn)(a)
}

public func const<A, B>(_ b: B) -> ((A) -> B) {
    return { _ in b }
}

public func lazy<A>(_ a: A) -> () -> A {
    return { a }
}

public func ignore<A>(_ a: A) {
    return ()
}

public func ignore<A>(of type: A.Type) -> (A) -> Void { { _ in () }
}

public func setter<Root, Value>(_ keyPath: WritableKeyPath<Root, Value>) -> (inout Root, Value) -> Void {
    return { root, value in
        root[keyPath: keyPath] = value
    }
}

/// `mutate(root:, with:)` is useful when you want to derive a value from an existing value instead of initializing from scratch.
/// It is basically a shortened & nicer syntax of a closure.
///
///     // Closure version
///     { root in
///         var mutableRoot = root
///         mutableRoot.value1 = ""
///         mutableRoot.value2 = 0
///         mutableRoot.value3 = false
///         return mutableRoot
///     }(root)
///
///     // `mutate(root:, with:)` version
///     mutate(root: root) {
///         mutableRoot.value1 = ""
///         mutableRoot.value2 = 0
///         mutableRoot.value3 = false
///     }
///
/// - Parameters:
///   - root: Root value for derivation.
///   - mutation: Closure where the derivation is applied.
/// - Returns: Derived version of root.
public func mutate<Root>(root: Root, with mutation: @escaping (inout Root) -> ()) -> Root {
    var root = root
    mutation(&root)
    return root
}

/// `mutate(root:, with:, for:)` is useful when you want to derive a value from an existing value instead of initializing from scratch.
/// It is basically a shortened & nicer syntax of a closure.
///
///     // Closure version
///     { root in
///         var mutableRoot = root
///         mutableRoot.value1 = "New!"
///         return mutableRoot
///     }(root)
///
///     // `mutate(root:, with:)` version
///     mutate(root: root, with: "New!", for: \.value1)
///
/// - Parameters:
///   - root: Root value for derivation.
///   - value: Value to be changed in the root.
///   - for: Keypath for the value in the root.
/// - Returns: Derived version of root.
public func mutate<Root, Value>(root: Root, with value: Value, for: WritableKeyPath<Root, Value>) -> Root {
    mutate(root: root) { $0[keyPath: `for`] = value }
}
