//
//  Result+Zip.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 30.11.18.
//  Copyright © 2018 Lautsprecher Teufel GmbH. All rights reserved.
//

// swiftlint:disable large_tuple
import Foundation

/// Creates a result of a pair built out of two wrapped result values if both succeed, or an error result with
/// left-hand-side error or right-hand-side error, what comes first.
///
/// - Parameters:
///   - resultLhs: first result type
///   - resultRhs: second result type
/// - Returns: result of a tuple
public func zip<RA: ResultType, RB: ResultType>(_ resultA: RA, _ resultB: RB)
    -> Result<(RA.Success, RB.Success), RA.Failure>
    where RA.Failure == RB.Failure {
        switch (resultA.asResult(), resultB.asResult()) {
        case let (.success(lhs), .success(rhs)):
            return .success((lhs, rhs))
        case (let .failure(error), _):
            return .failure(error)
        case (_, let .failure(error)):
            return .failure(error)
        }
}

/// Creates a result of a tuple built out of 3 wrapped result values, or an error result with the error found first
///
/// - Parameters:
///   - resultA: first result type
///   - resultB: second result type
///   - resultC: third result type
/// - Returns: result of a tuple
public func zip<RA: ResultType, RB: ResultType, RC: ResultType>(_ resultA: RA, _ resultB: RB, _ resultC: RC)
    -> Result<(RA.Success, RB.Success, RC.Success), RA.Failure>
    where RA.Failure == RB.Failure, RB.Failure == RC.Failure {
        return zip(resultA, zip(resultB, resultC)).map { sideA, sideBC in (sideA, sideBC.0, sideBC.1) }
}

/// Creates a result of a tuple built out of 4 wrapped result values, or an error result with the error found first
///
/// - Parameters:
///   - resultA: first result type
///   - resultB: second result type
///   - resultC: third result type
///   - resultD: fourth result type
/// - Returns: result of a tuple
public func zip<RA: ResultType, RB: ResultType, RC: ResultType, RD: ResultType>(_ resultA: RA, _ resultB: RB, _ resultC: RC, _ resultD: RD)
    -> Result<(RA.Success, RB.Success, RC.Success, RD.Success), RA.Failure>
    where RA.Failure == RB.Failure, RB.Failure == RC.Failure, RC.Failure == RD.Failure {
        return zip(resultA, zip(resultB, zip(resultC, resultD))).map { sideA, sideBCD in
            let sideB = sideBCD.0
            let sideCD = sideBCD.1
            let sideC = sideCD.0
            let sideD = sideCD.1

            return (sideA, sideB, sideC, sideD)
        }
}

extension ResultType {
    /// Zips the current result with a second, that is, it creates a result of a pair built out of two wrapped
    /// result values if both succeed, or an error result with left-hand-side error or right-hand-side error, what comes first.
    ///
    /// - Parameter other: a second result type
    /// - Returns: result of a tuple
    public func fanout<RB: ResultType>(_ other: @autoclosure () -> RB)
        -> Result<(Success, RB.Success), Failure>
        where RB.Failure == Failure {
        return zip(asResult(), other())
    }
}
