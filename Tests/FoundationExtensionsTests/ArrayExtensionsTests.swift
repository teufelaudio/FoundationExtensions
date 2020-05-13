//
//  ArrayExtensionsTests.swift
//  FoundationExtensionsTests
//
//  Created by Luiz Barbosa on 30.11.18.
//  Copyright © 2018 Lautsprecher Teufel GmbH. All rights reserved.
//

import FoundationExtensions
import XCTest

class ArrayExtensionsTests: XCTestCase {
    func testSafeSubcriptGetSuccess() {
        // given
        let array = [1, 2, 3, 4]

        // when
        let sut = array[safe: 2]

        // then
        XCTAssertEqual(3, sut)
    }

    func testSafeSubcriptSetSuccess() {
        // given
        var array = [1, 2, 3, 4]

        // when
        array[safe: 2] = 42

        // then
        XCTAssertEqual([1, 2, 42, 4], array)
    }

    func testSafeSubcriptGetNegative() {
        // given
        let array = [1, 2, 3, 4]

        // when
        let sut = array[safe: -2]

        // then
        XCTAssertNil(sut)
    }

    func testSafeSubcriptSetNegative() {
        // given
        var array = [1, 2, 3, 4]

        // when
        array[safe: -2] = 42

        // then
        XCTAssertEqual([1, 2, 3, 4], array)
    }

    func testSafeSubcriptGetOutOfBounds() {
        // given
        let array = [1, 2, 3, 4]

        // when
        let sut = array[safe: 4]

        // then
        XCTAssertNil(sut)
    }

    func testSafeSubcriptSetOutOfBounds() {
        // given
        var array = [1, 2, 3, 4]

        // when
        array[safe: 4] = 42

        // then
        XCTAssertEqual([1, 2, 3, 4], array)
    }

    func testRemoveSafeSubcriptSuccess() {
        // given
        var array = [1, 2, 3, 4]

        // when
        let sut = array.removeSafe(at: 2)

        // then
        XCTAssertEqual([1, 2, 4], array)
        XCTAssertEqual(3, sut)
    }

    func testRemoveSafeSubcriptNegative() {
        // given
        var array = [1, 2, 3, 4]

        // when
        let sut = array.removeSafe(at: -2)

        // then
        XCTAssertEqual([1, 2, 3, 4], array)
        XCTAssertNil(sut)
    }

    func testRemoveSafeSubcriptOutOfBounds() {
        // given
        var array = [1, 2, 3, 4]

        // when
        let sut = array.removeSafe(at: 4)

        // then
        XCTAssertEqual([1, 2, 3, 4], array)
        XCTAssertNil(sut)
    }
}

extension ArrayExtensionsTests {
    func testCartesianProductOfInts() {
        // given
        let lhs = [1, 2, 3]
        let rhs = [10, 20]
        let expectedResult = [
            (1, 10),
            (1, 20),
            (2, 10),
            (2, 20),
            (3, 10),
            (3, 20)
        ]

        // when
        let sut = Array.cartesian(lhs, rhs)

        // then
        XCTAssertEqual(expectedResult.count, sut.count)
        // Tuples are not Equatable, because they can't conform to procotols
        // :(
        expectedResult.enumerated().forEach { index, expectedTuple in
            let expectedLhs = expectedTuple.0
            let expectedRhs = expectedTuple.1
            let resultLhs = sut[index].0
            let resultRhs = sut[index].1

            XCTAssertEqual(expectedLhs, resultLhs)
            XCTAssertEqual(expectedRhs, resultRhs)
        }
    }

    func testCartesianProductOfIntsAndStrings() {
        // given
        // This is the example on documentation
        let lhs = [1, 3, 5]
        let rhs = ["a", "b"]
        let expectedResult = [(1, "a"), (1, "b"), (3, "a"), (3, "b"), (5, "a"), (5, "b")]

        // when
        let sut = Array.cartesian(lhs, rhs)

        // then
        XCTAssertEqual(expectedResult.count, sut.count)
        // Tuples are not Equatable, because they can't conform to procotols
        // :(
        expectedResult.enumerated().forEach { index, expectedTuple in
            let expectedLhs = expectedTuple.0
            let expectedRhs = expectedTuple.1
            let resultLhs = sut[index].0
            let resultRhs = sut[index].1

            XCTAssertEqual(expectedLhs, resultLhs)
            XCTAssertEqual(expectedRhs, resultRhs)
        }
    }

    func testApply() {
        // given
        // This is the example on documentation
        let values = [5, 7]
        let doubleMe: (Int) -> Int = { $0 * 2 }
        let negativeMe: (Int) -> Int = { $0 * -1 }
        let expectedResult = [10, -5, 14, -7]

        // when
        let sut = values.apply([doubleMe, negativeMe])

        // then
        XCTAssertEqual(expectedResult, sut)
    }

    func testLift() {
        // given
        // This is the example on documentation
        let stringify = [Int].lift(String.init)
        let firstArray = [1, 2]
        let expectedFirstArrayResult = ["1", "2"]
        let secondArray = [3, 4]
        let expectedSecondArrayResult = ["3", "4"]

        // when
        let firstArrayResult = stringify(firstArray)
        let secondArrayResult = stringify(secondArray)

        // then
        XCTAssertEqual(expectedFirstArrayResult, firstArrayResult)
        XCTAssertEqual(expectedSecondArrayResult, secondArrayResult)
    }

    func testFlatten() {
        // given
        // This is the example on documentation
        let nestedArray = [[1, 2], [3, 4, 5]]
        let expectedResult = [1, 2, 3, 4, 5]

        // when
        let sut = nestedArray.flatten()

        // then
        XCTAssertEqual(expectedResult, sut)
    }

    func testCall() {
        // given
        // This is the example on documentation
        let values = [5, 7]
        let doubleMe: (Int) -> Int = { $0 * 2 }
        let negativeMe: (Int) -> Int = { $0 * -1 }
        let expectedResult = [10, 14, -5, -7]

        // when
        let sut = [doubleMe, negativeMe].call(values)

        // then
        XCTAssertEqual(expectedResult, sut)
    }
}
