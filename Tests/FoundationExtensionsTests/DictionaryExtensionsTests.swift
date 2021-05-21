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

    enum AnotherKey: String {
        case baz
        case qux
        case barbuz
    }

    func testSubscriptByEnumKey() {
        let dict: [String: Int] = ["foo": 42, "bar": 23]
        XCTAssertEqual(dict[Key.foo], 42)
        XCTAssertEqual(dict[Key.bar], 23)

        XCTAssertNil(dict[AnotherKey.baz])        
    }
}
