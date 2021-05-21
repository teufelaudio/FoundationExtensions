//
//  DictionaryExtensionTests.swift
//  FoundationExtensionsTests
//
//  Copyright © 2021 Lautsprecher Teufel GmbH. All rights reserved.
//

import FoundationExtensions
import XCTest

class DictionaryExtensionTests: XCTestCase {
    enum Key: String {
        case foo
        case bar
    }

    func testSubscriptByEnumKey() {
        let dict: [String: Int] = ["foo": 42, "bar": 23]
        XCTAssertEqual(dict[Key.foo], 42)
        XCTAssertEqual(dict[Key.bar], 23)
    }
}
