//
//  StrideableExtensionsTests.swift
//  FoundationExtensionsTests
//
//  Created by Luiz Barbosa on 31.07.19.
//  Copyright © 2019 Lautsprecher Teufel GmbH. All rights reserved.
//

#if !os(watchOS)
import FoundationExtensions
import XCTest

class StrideableExtensionsTests: XCTestCase {

}

// MARK: - Range, for integers
extension StrideableExtensionsTests {
    func test42PlusMinus2Range() {
        // given
        let sut = 42

        // when
        let range = sut ± 2

        // then
        XCTAssertEqual(40...44, range)
    }

    func test42PlusMinus9Range() {
        // given
        let sut = 42

        // when
        let range = sut ± 9

        // then
        XCTAssertEqual(33...51, range)
    }

    func test42PlusMinusNegative9Range() {
        // given
        let sut = 42

        // when
        let range = sut ± -9

        // then
        XCTAssertEqual(33...51, range)
    }
}

// MARK: - Range, for floating-point
extension StrideableExtensionsTests {
    func test42PlusMinus0_2Range() {
        // given
        let sut = 42.0

        // when
        let range = sut ± 0.2

        // then
        XCTAssertEqual(41.8...42.2, range)
    }

    func test42PlusMinus3_9Range() {
        // given
        let sut = 42.0

        // when
        let range = sut ± 3.9

        // then
        XCTAssertEqual(38.1...45.9, range)
    }

    func test42PlusMinusNegative3_9Range() {
        // given
        let sut = 42.0

        // when
        let range = sut ± -3.9

        // then
        XCTAssertEqual(38.1...45.9, range)
    }
}

// MARK: - Approximately equal, for integers
extension StrideableExtensionsTests {
    func test42ApproximatelyEqual42PlusMinus2() {
        // given
        let sut = 42

        // when
        let result = sut ≅ 42 ± 2

        // then
        XCTAssertTrue(result)
    }

    func test42ApproximatelyEqual40PlusMinus2() {
        // given
        let sut = 42

        // when
        let result = sut ≅ 40 ± 2

        // then
        XCTAssertTrue(result)
    }

    func test42ApproximatelyEqual44PlusMinus2() {
        // given
        let sut = 42

        // when
        let result = sut ≅ 44 ± 2

        // then
        XCTAssertTrue(result)
    }

    func test42ApproximatelyEqual42PlusMinus0() {
        // given
        let sut = 42

        // when
        let result = sut ≅ 42 ± 0

        // then
        XCTAssertTrue(result)
    }

    func test42NotApproximatelyEqual44PlusMinus1() {
        // given
        let sut = 42

        // when
        let result = sut ≅ 44 ± 1

        // then
        XCTAssertFalse(result)
    }

    func test42NotApproximatelyEqual34PlusMinus9() {
        // given
        let sut = 42

        // when
        let result = sut ≅ 32 ± 9

        // then
        XCTAssertFalse(result)
    }
}

// MARK: - Approximately equal, for floating-point
extension StrideableExtensionsTests {
    func test42_42ApproximatelyEqual42_41PlusMinus0_2() {
        // given
        let sut = 42.42

        // when
        let result = sut ≅ 42.41 ± 0.2

        // then
        XCTAssertTrue(result)
    }

    func test42_42ApproximatelyEqual40_41PlusMinus2_02() {
        // given
        let sut = 42.42

        // when
        let result = sut ≅ 40.41 ± 2.02

        // then
        XCTAssertTrue(result)
    }

    func test42_42NotApproximatelyEqual40_40PlusMinus2_01() {
        // given
        let sut = 42.42

        // when
        let result = sut ≅ 40.40 ± 2.01

        // then
        XCTAssertFalse(result)
    }
}
#endif
