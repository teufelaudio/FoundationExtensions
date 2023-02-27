// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

public func zip<A, B>(_ a: A?, _ b: B?) -> (A, B)? {
    guard let a = a, let b = b else { return nil }
    return (a, b)
}

public func zip<A, B, C>(_ first: A?, _ second: B?, _ third: C?) -> (A, B, C)? { // swiftlint:disable:this large_tuple
    return zip(first, zip(second, third)).map { sideA, sideBC in (sideA, sideBC.0, sideBC.1) }
}

public func zip<A, B, C, D>(_ first: A?, _ second: B?, _ third: C?, _ fourth: D?) -> (A, B, C, D)? { // swiftlint:disable:this large_tuple
    return zip(first, zip(second, zip(third, fourth))).map { sideA, sideBCD in
        let sideB = sideBCD.0
        let sideCD = sideBCD.1
        let sideC = sideCD.0
        let sideD = sideCD.1

        return (sideA, sideB, sideC, sideD)
    }
}
