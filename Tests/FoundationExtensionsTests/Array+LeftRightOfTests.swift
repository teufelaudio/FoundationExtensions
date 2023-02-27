// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

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
        XCTAssertEqual(sut.right(of: 1), 3)
        XCTAssertEqual(sut.right(of: 9), 25)
        XCTAssertEqual(sut.right(of: 25), 1)
        XCTAssertEqual(sut.right(of: 666), nil)
    }

    func testLeftOf() {
        // whe
        let sut = [1, 3, 7, 9, 25]

        // then
        XCTAssertEqual(sut.left(of: 1), 25)
        XCTAssertEqual(sut.left(of: 3), 1)
        XCTAssertEqual(sut.left(of: 25), 9)
        XCTAssertEqual(sut.left(of: 666), nil)
    }
}
#endif
