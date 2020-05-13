//
//  BinaryFloatingPointExtensionsTests.swift
//  FoundationExtensionsTests
//
//  Created by Luis Reisewitz on 17.01.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

import XCTest

class BinaryFloatingPointExtensionsTests: XCTestCase {

}

// MARK: - Test Negate
extension BinaryFloatingPointExtensionsTests {
    func testNegateGreatestFiniteMagnitude() {
        // given
        let float = CGFloat.greatestFiniteMagnitude

        // when
        let sut = float.negated

        // then
        XCTAssertEqual(sut, -1 * CGFloat.greatestFiniteMagnitude)
    }

    func testNegateInfinity() {
        // given
        let float = CGFloat.infinity

        // when
        let sut = float.negated

        // then
        XCTAssertEqual(sut, -1 * CGFloat.infinity)
    }

    func testNegatePositive() {
        // given
        let float: CGFloat = 3.14159

        // when
        let sut = float.negated

        // then
        XCTAssertEqual(sut, -3.14159)
    }

    func testNegateNegative() {
        // given
        let float: CGFloat = -800

        // when
        let sut = float.negated

        // then
        XCTAssertEqual(sut, 800)
    }

    func testNegateZero() {
        // given
        let float: CGFloat = 0

        // when
        let sut = float.negated

        // then
        XCTAssertEqual(sut, 0)
    }

    func testNegateRandom() {
        10.times {
            // given
            let float = CGFloat.random()

            let sut = float.negated

            XCTAssertEqual(sut, float * -1, "Original CGFloat \(float) * -1 does not match SUT CGFloat \(sut)")
        }
    }
}

// MARK: - Test Random
extension BinaryFloatingPointExtensionsTests {
    func testRandom() {
        10.times {
            // when
            let sut = CGFloat.random()

            // then
            XCTAssert(
                (CGFloat.greatestFiniteMagnitude.negated...CGFloat.greatestFiniteMagnitude).contains(sut),
                "SUT \(sut) is not in range (CGFloat.greatestFiniteMagnitude.negated...CGFloat.greatestFiniteMagnitude)"
            )
        }
    }

    func testRandomSystemGenerator() {
        10.times {
            // given
            var generator = SystemRandomNumberGenerator()

            // when
            let sut = CGFloat.random(using: &generator)

            // then
            XCTAssert(
                (CGFloat.greatestFiniteMagnitude.negated...CGFloat.greatestFiniteMagnitude).contains(sut),
                "SUT \(sut) is not in range (CGFloat.greatestFiniteMagnitude.negated...CGFloat.greatestFiniteMagnitude)"
            )
        }
    }
}

// MARK: - Test `useSign`
extension BinaryFloatingPointExtensionsTests {
    func testUseSignNoChange() {
        // Given
        let value = -6.0

        // When
        let sut = value.useSign(from: -1)

        // Then
        XCTAssertEqual(sut, -6)
    }

    func testUseSignNegating() {
        // Given
        let value = 6.0

        // When
        let sut = value.useSign(from: -1)

        // Then
        XCTAssertEqual(sut, -6)
    }

    func testUseSignMakingPositive() {
        // Given
        let value = -6.0

        // When
        let sut = value.useSign(from: 1)

        // Then
        XCTAssertEqual(sut, 6)
    }

    func testUseSignZero() {
        // Given
        let value = 0.0

        // When
        let sut = value.useSign(from: -1)

        // Then
        XCTAssertEqual(sut, 0)
    }

    func testUseSignGreatestFiniteMagnite() {
        // Given
        let value = Double.greatestFiniteMagnitude

        // When
        let sut = value.useSign(from: -1)

        // Then
        XCTAssertEqual(sut, -1 * .greatestFiniteMagnitude)
    }

    func testUseSignInfinity() {
        // Given
        let value = Double.infinity

        // When
        let sut = value.useSign(from: -1)

        // Then
        XCTAssertEqual(sut, -1 * .infinity)
    }

    func testUseSignRandom() {
        10.times {
            // given
            let double = Double.random()

            let sutNegative = double.useSign(from: -1)
            let sutPositive = double.useSign(from: 1)

            XCTAssertEqual(sutNegative,
                           abs(double) * -1,
                           "SUT Negative Double \(sutNegative) does not match `abs(double) * -1` for value: \(double)"
            )
            XCTAssertEqual(sutPositive,
                           abs(double),
                           "SUT Positive Double \(sutPositive) does not match `abs(double)` for value: \(double)"
            )
        }
    }
}
