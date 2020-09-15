//
//  ArrayLeftRightOfTests.swift
//  FoundationExtensionsTests
//
//  Created by Thomas Mellenthin on 15.09.20.
//  Copyright © 2018 Lautsprecher Teufel GmbH. All rights reserved.
//

#if !os(watchOS)
import FoundationExtensions
import XCTest

class ArrayLeftRightOfTests: XCTestCase {
}

extension ArrayLeftRightOfTests {
    func testRightOf() {
        // whe
        let sut = [1, 3, 7, 9, 25]

        // then
        XCTAssertEqual(sut.rightOf(1), 3)
        XCTAssertEqual(sut.rightOf(9), 25)
        XCTAssertEqual(sut.rightOf(25), 1)
        XCTAssertEqual(sut.rightOf(666), nil)
    }

    func testLeftOf() {
        // whe
        let sut = [1, 3, 7, 9, 25]

        // then
        XCTAssertEqual(sut.leftOf(1), 25)
        XCTAssertEqual(sut.leftOf(3), 1)
        XCTAssertEqual(sut.leftOf(25), 9)
        XCTAssertEqual(sut.leftOf(666), nil)
    }
}
#endif
