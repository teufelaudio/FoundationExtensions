//
//  Operators.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 01.11.19.
//  Copyright © 2019 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

prefix operator ^
public prefix func ^ <Root, Value>(keyPath: KeyPath<Root, Value>) -> (Root) -> Value {
    return { root in
        root[keyPath: keyPath]
    }
}

public prefix func ^ <Root, Value1, Value2>(keyPaths: (KeyPath<Root, Value1>, KeyPath<Root, Value2>)) -> (Root) -> (Value1, Value2) {
    return { root in
        (root[keyPath: keyPaths.0], root[keyPath: keyPaths.1])
    }
}

public prefix func ^ <Root, Value1, Value2, Value3>(
        keyPaths: (KeyPath<Root, Value1>, KeyPath<Root, Value2>, KeyPath<Root, Value3>)
    ) -> (Root) -> (Value1, Value2, Value3) {
    return { root in
        (root[keyPath: keyPaths.0], root[keyPath: keyPaths.1], root[keyPath: keyPaths.2])
    }
}

public prefix func ^ <Root, Value1, Value2, Value3, Value4>(
        keyPaths: (KeyPath<Root, Value1>, KeyPath<Root, Value2>, KeyPath<Root, Value3>, KeyPath<Root, Value4>)
    ) -> (Root) -> (Value1, Value2, Value3, Value4) {
    return { root in
        (root[keyPath: keyPaths.0], root[keyPath: keyPaths.1], root[keyPath: keyPaths.2], root[keyPath: keyPaths.3])
    }
}

/*
 Pipe forward application operator
 |>

 Apply function
 - Left: value a: A
 - Right: function A to B
 - Return: value b: B

 * left associativity
 * precedence group: Forward Application
 */
infix operator |>: ForwardApplication
precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence
}

/*
 Forward composition operator / Right arrow operator
 >>>

 Compose two functions when output of the left matches input type of the right
 - Left: function A to B
 - Right: function B to C
 - Return: function A to C

 * left associativity
 * precedence group: Forward Composition
 * Forward Composition > Forward Application
 */
infix operator >>>: ForwardComposition
precedencegroup ForwardComposition {
    associativity: left
    higherThan: ForwardApplication
}

precedencegroup ApproximateEquality {
    associativity: left
    lowerThan: ComparisonPrecedence
    higherThan: LogicalConjunctionPrecedence
}

precedencegroup ToleranceRange {
    associativity: left
    lowerThan: AdditionPrecedence
    higherThan: ApproximateEquality
}

infix operator ±: ToleranceRange
infix operator ≅: ApproximateEquality
