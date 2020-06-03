//
//  StringExtensionsTest.swift
//  FoundationExtensionsTests
//
//  Created by Thomas Mellenthin on 30.01.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

#if !os(watchOS)
import XCTest

class StringExtensionsTest: XCTestCase {

    func testStringLeftPadding() {
        XCTAssertEqual("0a", "a".leftPadding(toLength: 2, withPad: "0")) // pad with one zero
        XCTAssertEqual("a", "a".leftPadding(toLength: 1, withPad: "0")) // no padding
        XCTAssertEqual("acab", "acab".leftPadding(toLength: 3, withPad: "0")) // no truncation
    }
}
#endif
