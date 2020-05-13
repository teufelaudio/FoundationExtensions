//
//  FunctionalExtensionsTests.swift
//  FoundationExtensionsTests
//
//  Created by Luiz Barbosa on 25.01.19.
//  Copyright © 2019 Lautsprecher Teufel GmbH. All rights reserved.
//

import FoundationExtensions
import XCTest

class FunctionalExtensionsTests: XCTestCase {
    func testCurry() {
        // given
        let joinToString: (Int, String) -> String = { int, string in "\(string)=>\(int)" }
        let sut = curry(joinToString)
        let join666ToString = sut(666)
        let join42ToString = sut(42)

        // when
        let devil = join666ToString("Devil")
        let hitchhiker = join42ToString("Hitchhiker")

        // then
        XCTAssertEqual("Devil=>666", devil)
        XCTAssertEqual("Hitchhiker=>42", hitchhiker)
    }

    func testFlip() {
        // given
        let joinToString: (Int, String) -> String = { int, string in "\(string)=>\(int)" }
        let sut = flip(joinToString)

        // when
        let devil = sut("Devil", 666)
        let hitchhiker = sut("Hitchhiker", 42)

        // then
        XCTAssertEqual("Devil=>666", devil)
        XCTAssertEqual("Hitchhiker=>42", hitchhiker)
    }

    func testIdentityOnObject() {
        // given
        let number: Int = 9876

        // when
        let numberComposedToIdentity = identity(number)

        // then
        XCTAssertEqual(number, numberComposedToIdentity)
    }

    func testIdentityOnFunction() {
        // given
        let arrayOfOptionals: [Int?] = [1, 2, 3, 5, nil, 8, 13, 21, 34, nil, nil, nil, 55, nil, 89, 144, nil, 233, nil]
        let expectedArrayCompacted: [Int] = [1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233]

        // when
        let arrayCompacted = arrayOfOptionals.compactMap(identity)

        // then
        XCTAssertEqual(expectedArrayCompacted, arrayCompacted)
    }
}
