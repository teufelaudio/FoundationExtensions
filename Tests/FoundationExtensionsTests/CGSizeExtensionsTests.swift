//
//  CGSizeExtensionsTests.swift
//  FoundationExtensionsTests
//
//  Created by Luis Reisewitz on 16.01.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

#if !os(watchOS)
import XCTest

class CGSizeExtensionsTests: XCTestCase {
    func testAsPointGreatestFiniteMagnitude() {
        // given
        let width = CGFloat.greatestFiniteMagnitude
        let height = CGFloat.greatestFiniteMagnitude * -1
        let size = CGSize(width: width, height: height)

        // when
        let sut = size.asPoint

        // then
        XCTAssertEqual(sut.x, CGFloat.greatestFiniteMagnitude)
        XCTAssertEqual(sut.y, CGFloat.greatestFiniteMagnitude.negated)
    }

    func testAsPointZero() {
        // given
        let width: CGFloat = 0
        let height = width
        let size = CGSize(width: width, height: height)

        // when
        let sut = size.asPoint

        // then
        XCTAssertEqual(sut.x, width)
        XCTAssertEqual(sut.y, height)
    }

    func testAsPointOther() {
        // given
        let width: CGFloat = .pi
        let height: CGFloat = -836.74839
        let size = CGSize(width: width, height: height)

        // when
        let sut = size.asPoint

        // then
        XCTAssertEqual(sut.x, width)
        XCTAssertEqual(sut.y, height)
    }

    func testAsPointRandom() {
        10.times {
            // given
            let width = CGFloat.random()
            let height = CGFloat.random()
            let size = CGSize(width: width, height: height)

            // when
            let sut = size.asPoint

            // then
            // If these tests fail, please read the message carefully and add
            // the failing input as a deterministic test case.
            XCTAssertEqual(sut.x, width, "CGPoint.x should match original CGSize.width. CGSize: \(size). CGPoint: \(sut)")
            XCTAssertEqual(sut.y, height, "CGPoint.y should match original CGSize.height. CGSize: \(size). CGPoint: \(sut)")
        }
    }
}
#endif
