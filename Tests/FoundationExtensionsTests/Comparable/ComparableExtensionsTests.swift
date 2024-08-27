// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if !os(watchOS)
import FoundationExtensions
import XCTest

class ComparableExtensionsTests: XCTestCase {
}

// MARK: - Constrain to rage
extension ComparableExtensionsTests {
    func testStringConstrain() {
        // given
        let tests = [
            (minimum: "d", maximum: "l", given: "d", expected: "d"),
            (minimum: "d", maximum: "l", given: "g", expected: "g"),
            (minimum: "d", maximum: "l", given: "l", expected: "l"),
            (minimum: "d", maximum: "l", given: "c", expected: "d"),
            (minimum: "d", maximum: "l", given: "a", expected: "d"),
            (minimum: "d", maximum: "l", given: "m", expected: "l"),
            (minimum: "d", maximum: "l", given: "z", expected: "l")
        ]

        // when
        let results: [(result: String, expected: String, failureMessage: String)] = tests.map {
            let result = $0.given.clamped(to: ($0.minimum ... $0.maximum))
            let failureMessage = "Expected \($0.given) when constrained to range from \($0.minimum) to \($0.maximum) " +
                "to be \($0.expected) but found \(result)"
            return (result: result, expected: $0.expected, failureMessage: failureMessage)
        }

        // then
        results.forEach {
            XCTAssertEqual($0.expected, $0.result, $0.failureMessage)
        }
    }

    func testNumericConstrain() {
        // given
        let tests = [
            (minimum: 0.0, maximum: 100.0, given: 0.0, expected: 0.0),
            (minimum: 0.0, maximum: 100.0, given: 50.0, expected: 50.0),
            (minimum: 0.0, maximum: 100.0, given: 100.0, expected: 100.0),
            (minimum: 0.0, maximum: 100.0, given: -0.01, expected: 0.0),
            (minimum: 0.0, maximum: 100.0, given: -1.0, expected: 0.0),
            (minimum: 0.0, maximum: 100.0, given: -1000.0, expected: 0.0),
            (minimum: 0.0, maximum: 100.0, given: 100.01, expected: 100.0),
            (minimum: 0.0, maximum: 100.0, given: 101.0, expected: 100.0),
            (minimum: 0.0, maximum: 100.0, given: 1000.0, expected: 100.0),
            (minimum: -100.0, maximum: 100.0, given: 0.0, expected: 0.0),
            (minimum: -100.0, maximum: 100.0, given: -1.0, expected: -1.0),
            (minimum: -100.0, maximum: 100.0, given: -101.0, expected: -100.0),
            (minimum: -100.0, maximum: 100.0, given: 101.0, expected: 100.0),
            (minimum: -100.0, maximum: -40.0, given: -45.0, expected: -45.0),
            (minimum: -100.0, maximum: -40.0, given: 30.0, expected: -40.0),
            (minimum: -100.0, maximum: -40.0, given: -30.0, expected: -40.0),
            (minimum: -100.0, maximum: -40.0, given: -101.0, expected: -100.0),
            (minimum: -100.0, maximum: -40.0, given: -99.0, expected: -99.0),
        ]

        // when
        let results: [(result: Double, expected: Double, failureMessage: String)] = tests.map {
            let result = $0.given.clamped(to: ($0.minimum ... $0.maximum))
            let failureMessage = "Expected \($0.given) when constrained to range from \($0.minimum) to \($0.maximum) " +
                "to be \($0.expected) but found \(result)"
            return (result: result, expected: $0.expected, failureMessage: failureMessage)
        }

        // then
        results.forEach {
            XCTAssertEqual($0.expected, $0.result, $0.failureMessage)
        }
    }
}

// MARK: - Within, for integers
extension ComparableExtensionsTests {
    func test42Within40to44() {
        // given
        let sut = 42

        // when
        let result = sut.within(40...44)

        // then
        XCTAssertTrue(result)
    }

    func test42Within40to42() {
        // given
        let sut = 42

        // when
        let result = sut.within(40...42)

        // then
        XCTAssertTrue(result)
    }

    func test42Within42to50() {
        // given
        let sut = 42

        // when
        let result = sut.within(42...50)

        // then
        XCTAssertTrue(result)
    }

    func test42Within42to42() {
        // given
        let sut = 42

        // when
        let result = sut.within(42...42)

        // then
        XCTAssertTrue(result)
    }

    func test42NotWithin43to50() {
        // given
        let sut = 42

        // when
        let result = sut.within(43...50)

        // then
        XCTAssertFalse(result)
    }

    func test42NotWithin30to41() {
        // given
        let sut = 42

        // when
        let result = sut.within(30...41)

        // then
        XCTAssertFalse(result)
    }
}

// MARK: - Within, for floating-point
extension ComparableExtensionsTests {
    func test42_42Within40_1to44_1() {
        // given
        let sut = 42.42

        // when
        let result = sut.within(40.1...44.1)

        // then
        XCTAssertTrue(result)
    }

    func test42_42Within40_1to42_43() {
        // given
        let sut = 42.42

        // when
        let result = sut.within(40.1...42.43)

        // then
        XCTAssertTrue(result)
    }

    func test42_42Within42_42to50_1() {
        // given
        let sut = 42.42

        // when
        let result = sut.within(42.42...50.1)

        // then
        XCTAssertTrue(result)
    }

    func test42_42Within42_42to42_42() {
        // given
        let sut = 42.42

        // when
        let result = sut.within(42.42...42.42)

        // then
        XCTAssertTrue(result)
    }

    func test42_42NotWithin42_43to50_1() {
        // given
        let sut = 42.42

        // when
        let result = sut.within(42.43...50.1)

        // then
        XCTAssertFalse(result)
    }

    func test42_42NotWithin30to42_41() {
        // given
        let sut = 42.42

        // when
        let result = sut.within(30.0...42.41)

        // then
        XCTAssertFalse(result)
    }
}

// MARK: - Within, for strings
extension ComparableExtensionsTests {
    func testDWithinCtoE() {
        // given
        let sut = "D"

        // when
        let result = sut.within("C"..."E")

        // then
        XCTAssertTrue(result)
    }

    func testDWithinBtoD() {
        // given
        let sut = "D"

        // when
        let result = sut.within("B"..."D")

        // then
        XCTAssertTrue(result)
    }

    func testDWithinDtoL() {
        // given
        let sut = "D"

        // when
        let result = sut.within("D"..."L")

        // then
        XCTAssertTrue(result)
    }

    func testDWithinDtoD() {
        // given
        let sut = "D"

        // when
        let result = sut.within("D"..."D")

        // then
        XCTAssertTrue(result)
    }

    func testDNotWithinEtoL() {
        // given
        let sut = "D"

        // when
        let result = sut.within("E"..."L")

        // then
        XCTAssertFalse(result)
    }

    func testDNotWithinAtoC() {
        // given
        let sut = "D"

        // when
        let result = sut.within("A"..."C")

        // then
        XCTAssertFalse(result)
    }
}
#endif
