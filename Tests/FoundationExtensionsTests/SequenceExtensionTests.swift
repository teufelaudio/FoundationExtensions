//
//  SequenceExtensionTests.swift
//  FoundationExtensionsTests
//
//  Created by Thomas Mellenthin on 29.01.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

import XCTest

class SequenceExtensionTests: XCTestCase {

    func testSequenceHex() {
        // given
        let input = "ABC".data(using: .ascii)!

        // when
        let sut = input.hex()

        // then
        XCTAssertEqual(sut, ["0x41", "0x42", "0x43"])
    }

    func testSequenceHexWithoutPrefix() {
        // given
        let input = "ABC".data(using: .ascii)!

        // when
        let sut = input.hex(withPrefix: false)

        // then
        XCTAssertEqual(sut, ["41", "42", "43"])
    }

    func testSequenceHexString() {
        // given
        let input = "ACAB".data(using: .ascii)!

        // when
        let sut = input.hexString()

        // then
        XCTAssertEqual(sut, "0x41434142")
    }

    func testSequenceHexStringWithoutPrefix() {
        // given
        let input = "ACAB".data(using: .ascii)!

        // when
        let sut = input.hexString(withPrefix: false)

        // then
        XCTAssertEqual(sut, "41434142")
    }
}
