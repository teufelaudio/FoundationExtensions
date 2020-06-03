//
//  Reader+Map.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 09.12.19.
//  Copyright © 2019 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

extension Reader {

    /// Maps the `Value` element, which is the result of the calculation, using a covariant function to be lifted.
    ///
    /// - We start with a dependency `X` to calculate `A`
    /// - We give a way for going from value `A` to `B`
    /// - Our resulting mapped Reader will accept dependency `X` to calculate `B`
    /// - Depdendency type hasn't changed at all
    public func mapValue<NewValue>(_ fn: @escaping (Value) -> NewValue) -> Reader<Environment, NewValue> {
        return Reader<Environment, NewValue> { environment in
            fn(self.inject(environment))
        }
    }

    /// Maps the `Environment` element, which is the input dependency of the calculation, using a contravariant function
    /// to be lifted.
    ///
    /// - We start with a dependency `X` to calculate `A`
    /// - We give a way to extract depdendency `X` from world `Y` (`Y` -> `X`)
    /// - Our resulting Reader will accept dependency `Y` to calculate `A`
    /// - Value type hasn't changed at all
    public func contramapEnvironment<EnvironmentPart>(_ fn: @escaping (EnvironmentPart) -> Environment) -> Reader<EnvironmentPart, Value> {
        return Reader<EnvironmentPart, Value> { environment2 in
            self.inject(fn(environment2))
        }
    }

    /// Maps the `Value` element, which is the result of the calculation, using a covariant function to be lifted.
    /// Also maps the `Environment` element, which is the input dependency of the calculation, using a contravariant function
    /// to be lifted.
    ///
    /// - We start with a dependency `X` to calculate `A`
    /// - We give a way for going from value `A` to `B`
    /// - We also give a way to extract depdendency `X` from world `Y` (`Y` -> `X`)
    /// - Our resulting mapped Reader will accept dependency `Y` to calculate `B`
    public func dimap<NewValue, EnvironmentPart>(mapValue value: @escaping (Value) -> NewValue,
                                                 contramapEnvironment environment: @escaping (EnvironmentPart) -> Environment)
        -> Reader<EnvironmentPart, NewValue> {
        return mapValue(value).contramapEnvironment(environment)
    }
}

extension Reader {
    /// Having a Reader mapping that results in another Reader that also depends on same environment, we can flatten up
    /// the map by using the same environment to inject in both Readers. Useful when there's a chain of dependencies
    public func flatMap<NewValue>(_ fn: @escaping (Value) -> Reader<Environment, NewValue>) -> Reader<Environment, NewValue> {
        return Reader<Environment, NewValue> { environment in
            fn(self.inject(environment)).inject(environment)
        }
    }
}

extension Reader {
    public func contramapEnvironment<E2, First, Second>(
        _ first: @escaping (E2) -> First,
        _ second: @escaping (E2) -> Second)
        -> Reader<E2, Value> where Environment == (First, Second) {
            return contramapEnvironment { Function.zip(first, second)($0) }
    }

    public func contramapEnvironment<E2, First, Second, Third>(
        _ first: @escaping (E2) -> First,
        _ second: @escaping (E2) -> Second,
        _ third: @escaping (E2) -> Third)
        -> Reader<E2, Value> where Environment == (First, Second, Third) {
            return contramapEnvironment { Function.zip(first, second, third)($0) }
    }

    public func contramapEnvironment<E2, First, Second, Third, Fourth>(
        _ first: @escaping (E2) -> First,
        _ second: @escaping (E2) -> Second,
        _ third: @escaping (E2) -> Third,
        _ fourth: @escaping (E2) -> Fourth)
        -> Reader<E2, Value> where Environment == (First, Second, Third, Fourth) {
            return contramapEnvironment { Function.zip(first, second, third, fourth)($0) }
    }

    public func contramapEnvironment<E2, First, Second, Third, Fourth, Fifth>(
        _ first: @escaping (E2) -> First,
        _ second: @escaping (E2) -> Second,
        _ third: @escaping (E2) -> Third,
        _ fourth: @escaping (E2) -> Fourth,
        _ fifth: @escaping (E2) -> Fifth)
        -> Reader<E2, Value> where Environment == (First, Second, Third, Fourth, Fifth) {
            return contramapEnvironment { Function.zip(first, second, third, fourth, fifth)($0) }
    }

    public func contramapEnvironment<E2, First, Second, Third, Fourth, Fifth, Sixth>(
        _ first: @escaping (E2) -> First,
        _ second: @escaping (E2) -> Second,
        _ third: @escaping (E2) -> Third,
        _ fourth: @escaping (E2) -> Fourth,
        _ fifth: @escaping (E2) -> Fifth,
        _ sixth: @escaping (E2) -> Sixth)
        -> Reader<E2, Value> where Environment == (First, Second, Third, Fourth, Fifth, Sixth) {
            return contramapEnvironment { Function.zip(first, second, third, fourth, fifth, sixth)($0) }
    }
}
