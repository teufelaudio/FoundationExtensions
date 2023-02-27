// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

/// Reader is a structure used mainly for dependency injection.
/// It's generic over 2 parameters: Environment and Value and can be reason as a function (Environment) -> Value, meaning
/// give me the dependencies (environment) I need and I give you the calculation. When you call a function that returns
/// Reader, the side-effects won't be called until you `inject` the dependencies, so it's a lazy operation.
/// It's exactly like Promises, but instead of waiting for async call, it's waiting for dependency injection lazily.
/// When you create a Promise no side-effect starts until you call `.run` providing the callback, when you create a
/// Reader no side-effect starts until you call `inject` providing the environment.
/// As Promises, it has higher-order functions to transform the shape of the reader generic parameters without actually
/// executing the side-effects, like Promises it has 2 generic parameters and can transform both of them, but unlike
/// Promises, Reader generic parameters operate in different directions: while Promises both sides (Success or Error)
/// are covariant (maps execute in the natural direction `(A) -> B` lifted to `(F<A>) -> F<B>`), Reader has one parameter
/// covariant, `Value`, that is mapped in the natural direction, while the other parameter, `Environment` is
/// contravariant, mapped in the opposite direction `(B) -> A` lifted to `(F<A>) -> F<B>`. This happens because
/// Environment is the input dependency of this function, similar to a `Predicate`.
/// An easy way to reason about Environment contravariance is that when you want to lift something that depends on a
/// subset into something that depends on the whole World, the function you must provide is actually in the direction of
/// `(World) -> Subset`.
/// This kind of object with two generic parameters in opposite directions has the Mathematical name of `Profunctor` and
/// functions `map` for the covariant element, `contramap` for the contravariant element and `dimap` that is a double-map
/// in opposite directions.
public final class Reader<Environment, Value> {
    /// Unwrap the `Value` by providing the dependencies (`Environment`). This will inject the dependencies and run
    /// the side-effects. After that, `Reader` is no longer needed.
    public let inject: (Environment) -> Value

    /// Creates a `Reader` from a function that, given necessary `Environment` dependencies, performs a calculation of a `Value`
    public init(_ inject: @escaping (Environment) -> Value) {
        self.inject = inject
    }
}
