// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if !os(watchOS)
import XCTest

class CGPointExtensionsTests: XCTestCase {

}

// MARK: - Test AdditiveArithmetic Conformance
extension CGPointExtensionsTests {
    func testAddingContainingZero() {
        // given
        let point1 = CGPoint(x: 0, y: 5)
        let point2 = CGPoint(x: 5, y: 3)

        // when
        let sut = point1 + point2

        // then
        XCTAssertEqual(sut.x, 5)
        XCTAssertEqual(sut.y, 8)
    }

    func testAddingContainingNegative() {
        // given
        let point1 = CGPoint(x: -13, y: 8)
        let point2 = CGPoint(x: 6, y: 11)

        // when
        let sut = point1 + point2

        // then
        XCTAssertEqual(sut.x, -7)
        XCTAssertEqual(sut.y, 19)
    }

    func testAddingRandom() {
        10.times {
            // given
            let point1 = CGPoint(x: CGFloat.random(), y: CGFloat.random())
            let point2 = CGPoint(x: CGFloat.random(), y: CGFloat.random())

            // when
            let sut = point1 + point2

            // then
            XCTAssertEqual(sut.x, point1.x + point2.x, "Point1.x \(point1) + Point2.x \(point2) does not match result Point.x \(sut)")
            XCTAssertEqual(sut.y, point1.y + point2.y, "Point1.y \(point1) + Point2.y \(point2) does not match result Point.y \(sut)")
        }
    }

    func testSubtractingContainingZero() {
        // given
        let point1 = CGPoint(x: 0, y: 5)
        let point2 = CGPoint(x: 5, y: 3)

        // when
        let sut = point1 - point2

        // then
        XCTAssertEqual(sut.x, -5)
        XCTAssertEqual(sut.y, 2)
    }

    func testSubtractingContainingNegative() {
        // given
        let point1 = CGPoint(x: -13, y: 8)
        let point2 = CGPoint(x: 6, y: 11)

        // when
        let sut = point1 - point2

        // then
        XCTAssertEqual(sut.x, -19)
        XCTAssertEqual(sut.y, -3)
    }

    func testSubtractingRandom() {
        10.times {
            // given
            let point1 = CGPoint(x: CGFloat.random(), y: CGFloat.random())
            let point2 = CGPoint(x: CGFloat.random(), y: CGFloat.random())

            // when
            let sut = point1 - point2

            // then
            XCTAssertEqual(sut.x, point1.x - point2.x, "Point1.x \(point1) - Point2.x \(point2) does not match result Point.x \(sut)")
            XCTAssertEqual(sut.y, point1.y - point2.y, "Point1.y \(point1) - Point2.y \(point2) does not match result Point.y \(sut)")
        }
    }

    func testInPlaceAddingContainingZero() {
        // given
        let point1 = CGPoint(x: 0, y: 5)
        let point2 = CGPoint(x: 5, y: 3)

        // when
        var sut = point1
        sut += point2

        // then
        XCTAssertEqual(sut.x, 5)
        XCTAssertEqual(sut.y, 8)
    }

    func testInPlaceAddingContainingNegative() {
        // given
        let point1 = CGPoint(x: -13, y: 8)
        let point2 = CGPoint(x: 6, y: 11)

        // when
        var sut = point1
        sut += point2

        // then
        XCTAssertEqual(sut.x, -7)
        XCTAssertEqual(sut.y, 19)
    }

    func testInPlaceAddingRandom() {
        10.times {
            // given
            let point1 = CGPoint(x: CGFloat.random(), y: CGFloat.random())
            let point2 = CGPoint(x: CGFloat.random(), y: CGFloat.random())

            // when
            var sut = point1
            sut += point2

            // then
            XCTAssertEqual(sut.x, point1.x + point2.x, "Point1.x \(point1) + Point2.x \(point2) does not match result Point.x \(sut)")
            XCTAssertEqual(sut.y, point1.y + point2.y, "Point1.y \(point1) + Point2.y \(point2) does not match result Point.y \(sut)")
        }
    }

    func testInPlaceSubtractingContainingZero() {
        // given
        let point1 = CGPoint(x: 0, y: 5)
        let point2 = CGPoint(x: 5, y: 3)

        // when
        var sut = point1
        sut -= point2

        // then
        XCTAssertEqual(sut.x, -5)
        XCTAssertEqual(sut.y, 2)
    }

    func testInPlaceSubtractingContainingNegative() {
        // given
        let point1 = CGPoint(x: -13, y: 8)
        let point2 = CGPoint(x: 6, y: 11)

        // when
        var sut = point1
        sut -= point2

        // then
        XCTAssertEqual(sut.x, -19)
        XCTAssertEqual(sut.y, -3)
    }

    func testInPlaceSubtractingRandom() {
        10.times {
            let point1 = CGPoint(x: CGFloat.random(), y: CGFloat.random())
            // given
            let point2 = CGPoint(x: CGFloat.random(), y: CGFloat.random())

            // when
            var sut = point1
            sut -= point2

            // then
            XCTAssertEqual(sut.x, point1.x - point2.x, "Point1.x \(point1) - Point2.x \(point2) does not match result Point.x \(sut)")
            XCTAssertEqual(sut.y, point1.y - point2.y, "Point1.y \(point1) - Point2.y \(point2) does not match result Point.y \(sut)")
        }
    }
}

// MARK: - Test `CGPoint.noX`
extension CGPointExtensionsTests {
    func testNoXPositive() {
        // given
        let point = CGPoint(x: 200, y: 200)

        // when
        let sut = point.noX

        // then
        XCTAssertEqual(sut.x, 0)
        XCTAssertEqual(sut.y, 200)
    }

    func testNoXNegative() {
        // given
        let point = CGPoint(x: -200, y: -200)

        // when
        let sut = point.noX

        // then
        XCTAssertEqual(sut.x, 0)
        XCTAssertEqual(sut.y, -200)
    }

    func testNoXZero() {
        // given
        let point = CGPoint(x: 0, y: 200)

        // when
        let sut = point.noX

        // then
        XCTAssertEqual(sut.x, 0)
        XCTAssertEqual(sut.y, 200)
    }

    func testNoXVerySmallX() {
        // given
        let point = CGPoint(x: 0.0000001, y: 200)

        // when
        let sut = point.noX

        // then
        XCTAssertEqual(sut.x, 0)
        XCTAssertEqual(sut.y, 200)
    }

    func testNoXRandom() {
        10.times {
            // given
            let point = CGPoint(x: CGFloat.random(), y: CGFloat.random())

            // when
            let sut = point.noX

            // then
            XCTAssertEqual(sut.x, 0, "Result Point.x \(sut) does not match 0 for original point \(point)")
            XCTAssertEqual(sut.y, point.y, "Result Point.y \(sut) does not match original point.y \(point)")
        }
    }
}

// MARK: - Test `CGPoint.onlyPositive`
extension CGPointExtensionsTests {
    func testOnlyPositivePositive() {
        // given
        let point = CGPoint(x: 200, y: 200)

        // when
        let sut = point.onlyPositive

        // then
        XCTAssertEqual(sut.x, 200)
        XCTAssertEqual(sut.y, 200)
    }

    func testOnlyPositiveNegative() {
        // given
        let point = CGPoint(x: -200, y: -200)

        // when
        let sut = point.onlyPositive

        // then
        XCTAssertEqual(sut.x, 0)
        XCTAssertEqual(sut.y, 0)
    }

    func testOnlyPositiveZero() {
        // given
        let point = CGPoint(x: 0, y: 200)

        // when
        let sut = point.onlyPositive

        // then
        XCTAssertEqual(sut.x, 0)
        XCTAssertEqual(sut.y, 200)
    }

    func testOnlyPositiveVerySmallX() {
        // given
        let point = CGPoint(x: 0.0000001, y: 200)

        // when
        let sut = point.onlyPositive

        // then
        XCTAssertEqual(sut.x, 0.0000001)
        XCTAssertEqual(sut.y, 200)
    }

    func testOnlyPositiveVerySmallY() {
        // given
        let point = CGPoint(x: 200, y: 0.0000001)

        // when
        let sut = point.onlyPositive

        // then
        XCTAssertEqual(sut.x, 200)
        XCTAssertEqual(sut.y, 0.0000001)
    }

    func testOnlyPositiveRandom() {
        10.times {
            // given
            let point = CGPoint(x: CGFloat.random(), y: CGFloat.random())

            // when
            let sut = point.onlyPositive

            // then
            XCTAssertEqual(
                sut.x,
                point.x >= 0 ? point.x : 0,
                "Result Point.x \(sut) is not constrained to only positive for original point.x \(point)")
            XCTAssertEqual(
                sut.y,
                point.y >= 0 ? point.y : 0,
                "Result Point.y \(sut) is not constrained to only positive for original point.y \(point)")
        }
    }
}
#endif
