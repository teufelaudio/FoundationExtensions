// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if !os(watchOS)
import FoundationExtensions
import XCTest

class NumericExtensionsTests: XCTestCase {
    func testLinearInterpolation() {
        // given
        let tests = [
            (minimum: 0.0, maximum: 100.0, percentage: 0.0 / 100.0, expected: 0.0),
            (minimum: 0.0, maximum: 100.0, percentage: 20.0 / 100.0, expected: 20.0),
            (minimum: 0.0, maximum: 100.0, percentage: 50.0 / 100.0, expected: 50.0),
            (minimum: 0.0, maximum: 100.0, percentage: 79.0 / 100.0, expected: 79.0),
            (minimum: 0.0, maximum: 100.0, percentage: 100.0 / 100.0, expected: 100.0),
            (minimum: 0.0, maximum: 100.0, percentage: 102.0 / 100.0, expected: 102.0),

            (minimum: 0.0, maximum: 50.0, percentage: 0.0 / 100.0, expected: 0.0),
            (minimum: 0.0, maximum: 50.0, percentage: 20.0 / 100.0, expected: 10.0),
            (minimum: 0.0, maximum: 50.0, percentage: 50.0 / 100.0, expected: 25.0),
            (minimum: 0.0, maximum: 50.0, percentage: 79.0 / 100.0, expected: 39.5),
            (minimum: 0.0, maximum: 50.0, percentage: 100.0 / 100.0, expected: 50.0),
            (minimum: 0.0, maximum: 50.0, percentage: 102.0 / 100.0, expected: 51.0),

            (minimum: 50.0, maximum: 100.0, percentage: 0.0 / 100.0, expected: 50.0),
            (minimum: 50.0, maximum: 100.0, percentage: 20.0 / 100.0, expected: 60.0),
            (minimum: 50.0, maximum: 100.0, percentage: 50.0 / 100.0, expected: 75.0),
            (minimum: 50.0, maximum: 100.0, percentage: 79.0 / 100.0, expected: 89.5),
            (minimum: 50.0, maximum: 100.0, percentage: 100.0 / 100.0, expected: 100.0),
            (minimum: 50.0, maximum: 100.0, percentage: 102.0 / 100.0, expected: 101.0)
        ]

        // when
        let results: [(result: Double, expected: Double, failureMessage: String)] = tests.map {
            let result = Double.linearInterpolation(minimum: $0.minimum, maximum: $0.maximum, percentage: $0.percentage, constrainedToValidPercentage: false)
            let failureMessage = "Expected interpolation from \($0.minimum) to \($0.maximum) on " +
                "\($0.percentage * 100)% to be \($0.expected) but found \(result)"
            return (result: result, expected: $0.expected, failureMessage: failureMessage)
        }

        // then
        results.forEach {
            XCTAssertEqual($0.expected, $0.result, $0.failureMessage)
        }
    }

    func testLinearProgressConstrainedToValidPercentage() {
        // given
        let tests = [
            (minimum: 0.0, maximum: 100.0, current: 0.0, expected: 0.0 / 100.0),
            (minimum: 0.0, maximum: 100.0, current: 20.0, expected: 20.0 / 100.0),
            (minimum: 0.0, maximum: 100.0, current: 50.0, expected: 50.0 / 100.0),
            (minimum: 0.0, maximum: 100.0, current: 79.0, expected: 79.0 / 100.0),
            (minimum: 0.0, maximum: 100.0, current: 100.0, expected: 100.0 / 100.0),
            (minimum: 0.0, maximum: 100.0, current: 102.0, expected: 100.0 / 100.0),

            (minimum: 0.0, maximum: 50.0, current: 0.0, expected: 0.0 / 100.0),
            (minimum: 0.0, maximum: 50.0, current: 10.0, expected: 20.0 / 100.0),
            (minimum: 0.0, maximum: 50.0, current: 25.0, expected: 50.0 / 100.0),
            (minimum: 0.0, maximum: 50.0, current: 39.5, expected: 79.0 / 100.0),
            (minimum: 0.0, maximum: 50.0, current: 50.0, expected: 100.0 / 100.0),
            (minimum: 0.0, maximum: 50.0, current: 51.0, expected: 100.0 / 100.0),

            (minimum: 50.0, maximum: 100.0, current: 50.0, expected: 0.0 / 100.0),
            (minimum: 50.0, maximum: 100.0, current: 60.0, expected: 20.0 / 100.0),
            (minimum: 50.0, maximum: 100.0, current: 75.0, expected: 50.0 / 100.0),
            (minimum: 50.0, maximum: 100.0, current: 89.5, expected: 79.0 / 100.0),
            (minimum: 50.0, maximum: 100.0, current: 100.0, expected: 100.0 / 100.0),
            (minimum: 50.0, maximum: 100.0, current: 101.0, expected: 100.0 / 100.0)
        ]

        // when
        let results: [(result: Double, expected: Double, failureMessage: String)] = tests.map {
            let result = Double.linearProgress(minimum: $0.minimum, maximum: $0.maximum, current: $0.current)
            let failureMessage = "Expected interpolation from \($0.minimum) to \($0.maximum) on " +
                "\($0.current) to be \($0.expected * 100)% but found \(result * 100)%"
            return (result: result, expected: $0.expected, failureMessage: failureMessage)
        }

        // then
        results.forEach {
            XCTAssertEqual($0.expected, $0.result, $0.failureMessage)
        }
    }

    func testLinearProgressNotConstrainedToValidPercentage() {
        // given
        let tests = [
            (minimum: 0.0, maximum: 100.0, current: 0.0, expected: 0.0 / 100.0),
            (minimum: 0.0, maximum: 100.0, current: 20.0, expected: 20.0 / 100.0),
            (minimum: 0.0, maximum: 100.0, current: 50.0, expected: 50.0 / 100.0),
            (minimum: 0.0, maximum: 100.0, current: 79.0, expected: 79.0 / 100.0),
            (minimum: 0.0, maximum: 100.0, current: 100.0, expected: 100.0 / 100.0),
            (minimum: 0.0, maximum: 100.0, current: 102.0, expected: 102.0 / 100.0),

            (minimum: 0.0, maximum: 50.0, current: 0.0, expected: 0.0 / 100.0),
            (minimum: 0.0, maximum: 50.0, current: 10.0, expected: 20.0 / 100.0),
            (minimum: 0.0, maximum: 50.0, current: 25.0, expected: 50.0 / 100.0),
            (minimum: 0.0, maximum: 50.0, current: 39.5, expected: 79.0 / 100.0),
            (minimum: 0.0, maximum: 50.0, current: 50.0, expected: 100.0 / 100.0),
            (minimum: 0.0, maximum: 50.0, current: 51.0, expected: 102.0 / 100.0),

            (minimum: 50.0, maximum: 100.0, current: 50.0, expected: 0.0 / 100.0),
            (minimum: 50.0, maximum: 100.0, current: 60.0, expected: 20.0 / 100.0),
            (minimum: 50.0, maximum: 100.0, current: 75.0, expected: 50.0 / 100.0),
            (minimum: 50.0, maximum: 100.0, current: 89.5, expected: 79.0 / 100.0),
            (minimum: 50.0, maximum: 100.0, current: 100.0, expected: 100.0 / 100.0),
            (minimum: 50.0, maximum: 100.0, current: 101.0, expected: 102.0 / 100.0)
        ]

        // when
        let results: [(result: Double, expected: Double, failureMessage: String)] = tests.map {
            let result = Double.linearProgress(minimum: $0.minimum, maximum: $0.maximum, current: $0.current, constrainedToValidPercentage: false)
            let failureMessage = "Expected interpolation from \($0.minimum) to \($0.maximum) on " +
                "\($0.current) to be \($0.expected * 100)% but found \(result * 100)%"
            return (result: result, expected: $0.expected, failureMessage: failureMessage)
        }

        // then
        results.forEach {
            XCTAssertEqual($0.expected, $0.result, $0.failureMessage)
        }
    }

    func testLogisticFunction() {
        // given
        let tests = [
            (L: 100.0 / 100.0, k: 1.0, x: 0.0 / 100.0, x₀: 50.0 / 100.0, expected: 37.75406687981454 / 100.0),
            (L: 100.0 / 100.0, k: 1.0, x: 20.0 / 100.0, x₀: 50.0 / 100.0, expected: 42.55574831883411 / 100.0),
            (L: 100.0 / 100.0, k: 1.0, x: 50.0 / 100.0, x₀: 50.0 / 100.0, expected: 50.0 / 100.0),
            (L: 100.0 / 100.0, k: 1.0, x: 79.0 / 100.0, x₀: 50.0 / 100.0, expected: 57.19961329315186 / 100.0),
            (L: 100.0 / 100.0, k: 1.0, x: 100.0 / 100.0, x₀: 50.0 / 100.0, expected: 62.24593312018546 / 100.0),
            (L: 100.0 / 100.0, k: 1.0, x: 102.0 / 100.0, x₀: 50.0 / 100.0, expected: 62.71477663131956 / 100.0),

            (L: 100.0 / 100.0, k: 0.5, x: 0.0 / 100.0, x₀: 50.0 / 100.0, expected: 43.782349911420193 / 100.0),
            (L: 100.0 / 100.0, k: 0.5, x: 20.0 / 100.0, x₀: 50.0 / 100.0, expected: 46.257015465625045 / 100.0),
            (L: 100.0 / 100.0, k: 0.5, x: 50.0 / 100.0, x₀: 50.0 / 100.0, expected: 50.0 / 100.0),
            (L: 100.0 / 100.0, k: 0.5, x: 79.0 / 100.0, x₀: 50.0 / 100.0, expected: 53.61866202317948 / 100.0),
            (L: 100.0 / 100.0, k: 0.5, x: 100.0 / 100.0, x₀: 50.0 / 100.0, expected: 56.21765008857981 / 100.0),
            (L: 100.0 / 100.0, k: 0.5, x: 102.0 / 100.0, x₀: 50.0 / 100.0, expected: 56.46362918030292 / 100.0),

            (L: 50.0 / 100.0, k: 1.0, x: 0.0 / 100.0, x₀: 50.0 / 100.0, expected: 37.75406687981454 / 200.0),
            (L: 50.0 / 100.0, k: 1.0, x: 20.0 / 100.0, x₀: 50.0 / 100.0, expected: 42.55574831883411 / 200.0),
            (L: 50.0 / 100.0, k: 1.0, x: 50.0 / 100.0, x₀: 50.0 / 100.0, expected: 50.0 / 200.0),
            (L: 50.0 / 100.0, k: 1.0, x: 79.0 / 100.0, x₀: 50.0 / 100.0, expected: 57.19961329315186 / 200.0),
            (L: 50.0 / 100.0, k: 1.0, x: 100.0 / 100.0, x₀: 50.0 / 100.0, expected: 62.24593312018546 / 200.0),
            (L: 50.0 / 100.0, k: 1.0, x: 102.0 / 100.0, x₀: 50.0 / 100.0, expected: 62.71477663131956 / 200.0)
        ]

        // when
        let results: [(result: Double, expected: Double, failureMessage: String)] = tests.map {
            let result = Double.logistic(x: $0.x, L: $0.L, k: $0.k, x₀: $0.x₀)
            let failureMessage = "Expected y to be \($0.expected) when L=\($0.L), k=\($0.k), x=\($0.x) and x₀=\($0.x₀). Got value \(result), however."
            return (result: result, expected: $0.expected, failureMessage: failureMessage)
        }

        // then
        results.forEach {
            XCTAssertEqual($0.expected, $0.result, accuracy: 10e-10, $0.failureMessage)
        }

    }

    func testIntLinearInterpolation() {
        // given
        let tests = [
            (minimum: 0, maximum: 100, percentage: 0.0 / 100.0, expected: 0.0),
            (minimum: 0, maximum: 100, percentage: 20.0 / 100.0, expected: 20.0),
            (minimum: 0, maximum: 100, percentage: 50.0 / 100.0, expected: 50.0),
            (minimum: 0, maximum: 100, percentage: 79.0 / 100.0, expected: 79.0),
            (minimum: 0, maximum: 100, percentage: 100.0 / 100.0, expected: 100.0),
            (minimum: 0, maximum: 100, percentage: 102.0 / 100.0, expected: 102.0),

            (minimum: 0, maximum: 50, percentage: 0.0 / 100.0, expected: 0.0),
            (minimum: 0, maximum: 50, percentage: 20.0 / 100.0, expected: 10.0),
            (minimum: 0, maximum: 50, percentage: 50.0 / 100.0, expected: 25.0),
            (minimum: 0, maximum: 50, percentage: 79.0 / 100.0, expected: 39.5),
            (minimum: 0, maximum: 50, percentage: 100.0 / 100.0, expected: 50.0),
            (minimum: 0, maximum: 50, percentage: 102.0 / 100.0, expected: 51.0),

            (minimum: 50, maximum: 100, percentage: 0.0 / 100.0, expected: 50.0),
            (minimum: 50, maximum: 100, percentage: 20.0 / 100.0, expected: 60.0),
            (minimum: 50, maximum: 100, percentage: 50.0 / 100.0, expected: 75.0),
            (minimum: 50, maximum: 100, percentage: 79.0 / 100.0, expected: 89.5),
            (minimum: 50, maximum: 100, percentage: 100.0 / 100.0, expected: 100.0),
            (minimum: 50, maximum: 100, percentage: 102.0 / 100.0, expected: 101.0)
        ]

        // when
        let results: [(result: Double, expected: Double, failureMessage: String)] = tests.map {
            let result = Int.linearInterpolation(minimum: $0.minimum, maximum: $0.maximum, percentage: $0.percentage, constrainedToValidPercentage: false)
            let failureMessage = "Expected interpolation from \($0.minimum) to \($0.maximum) on " +
            "\($0.percentage * 100)% to be \($0.expected) but found \(result)"
            return (result: result, expected: $0.expected, failureMessage: failureMessage)
        }

        // then
        results.forEach {
            XCTAssertEqual($0.expected, $0.result, $0.failureMessage)
        }
    }

    func testIntLinearProgressConstrainedToValidPercentage() {
        // given
        let tests = [
            (minimum: 0, maximum: 100, current: 0, expected: 0.0 / 100.0),
            (minimum: 0, maximum: 100, current: 20, expected: 20.0 / 100.0),
            (minimum: 0, maximum: 100, current: 50, expected: 50.0 / 100.0),
            (minimum: 0, maximum: 100, current: 79, expected: 79.0 / 100.0),
            (minimum: 0, maximum: 100, current: 100, expected: 100.0 / 100.0),
            (minimum: 0, maximum: 100, current: 102, expected: 100.0 / 100.0),

            (minimum: 0, maximum: 50, current: 0, expected: 0.0 / 100.0),
            (minimum: 0, maximum: 50, current: 10, expected: 20.0 / 100.0),
            (minimum: 0, maximum: 50, current: 25, expected: 50.0 / 100.0),
            (minimum: 0, maximum: 50, current: 39, expected: 78.0 / 100.0),
            (minimum: 0, maximum: 50, current: 50, expected: 100.0 / 100.0),
            (minimum: 0, maximum: 50, current: 51, expected: 100.0 / 100.0),

            (minimum: 50, maximum: 100, current: 50, expected: 0.0 / 100.0),
            (minimum: 50, maximum: 100, current: 60, expected: 20.0 / 100.0),
            (minimum: 50, maximum: 100, current: 75, expected: 50.0 / 100.0),
            (minimum: 50, maximum: 100, current: 89, expected: 78.0 / 100.0),
            (minimum: 50, maximum: 100, current: 100, expected: 100.0 / 100.0),
            (minimum: 50, maximum: 100, current: 101, expected: 100.0 / 100.0)
        ]

        // when
        let results: [(result: Double, expected: Double, failureMessage: String)] = tests.map {
            let result = Int.linearProgress(minimum: $0.minimum, maximum: $0.maximum, current: $0.current)
            let failureMessage = "Expected interpolation from \($0.minimum) to \($0.maximum) on " +
            "\($0.current) to be \($0.expected * 100)% but found \(result * 100)%"
            return (result: result, expected: $0.expected, failureMessage: failureMessage)
        }

        // then
        results.forEach {
            XCTAssertEqual($0.expected, $0.result, $0.failureMessage)
        }
    }

    func testIntLinearProgressNotConstrainedToValidPercentage() {
        // given
        let tests = [
            (minimum: 0, maximum: 100, current: 0, expected: 0.0 / 100.0),
            (minimum: 0, maximum: 100, current: 20, expected: 20.0 / 100.0),
            (minimum: 0, maximum: 100, current: 50, expected: 50.0 / 100.0),
            (minimum: 0, maximum: 100, current: 79, expected: 79.0 / 100.0),
            (minimum: 0, maximum: 100, current: 100, expected: 100.0 / 100.0),
            (minimum: 0, maximum: 100, current: 102, expected: 102.0 / 100.0),

            (minimum: 0, maximum: 50, current: 0, expected: 0.0 / 100.0),
            (minimum: 0, maximum: 50, current: 10, expected: 20.0 / 100.0),
            (minimum: 0, maximum: 50, current: 25, expected: 50.0 / 100.0),
            (minimum: 0, maximum: 50, current: 39, expected: 78.0 / 100.0),
            (minimum: 0, maximum: 50, current: 50, expected: 100.0 / 100.0),
            (minimum: 0, maximum: 50, current: 51, expected: 102.0 / 100.0),

            (minimum: 50, maximum: 100, current: 50, expected: 0.0 / 100.0),
            (minimum: 50, maximum: 100, current: 60, expected: 20.0 / 100.0),
            (minimum: 50, maximum: 100, current: 75, expected: 50.0 / 100.0),
            (minimum: 50, maximum: 100, current: 89, expected: 78.0 / 100.0),
            (minimum: 50, maximum: 100, current: 100, expected: 100.0 / 100.0),
            (minimum: 50, maximum: 100, current: 101, expected: 102.0 / 100.0)
        ]

        // when
        let results: [(result: Double, expected: Double, failureMessage: String)] = tests.map {
            let result = Int.linearProgress(minimum: $0.minimum, maximum: $0.maximum, current: $0.current, constrainedToValidPercentage: false)
            let failureMessage = "Expected interpolation from \($0.minimum) to \($0.maximum) on " +
            "\($0.current) to be \($0.expected * 100)% but found \(result * 100)%"
            return (result: result, expected: $0.expected, failureMessage: failureMessage)
        }

        // then
        results.forEach {
            XCTAssertEqual($0.expected, $0.result, $0.failureMessage)
        }
    }
}
#endif
