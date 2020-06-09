//
//  CollectionExtensionTests.swift
//  FoundationExtensionsTests
//
//  Created by Luiz Barbosa on 30.11.18.
//  Copyright © 2018 Lautsprecher Teufel GmbH. All rights reserved.
//

#if !os(watchOS)
import FoundationExtensions
import XCTest

class CollectionExtensionTests: XCTestCase {
    struct User: Equatable {
        var name: String
        var city: String
    }

    func testUpdateElementUsingKeypathEmptyArray() {
        // given
        let originalList = [User]()
        let predicate: (User) -> Bool = { $0.name == "Blob" }
        let keyPath = \User.city
        let newValue = "Berlin"
        let expectedResponseList = [User]()

        // when
        let newList = originalList.updateElement(where: predicate, keyPath: keyPath, value: newValue)

        // then
        XCTAssertEqual(expectedResponseList, newList)
    }

    func testUpdateElementUsingKeypathNoChanges() {
        // given
        let originalList = [
            User(name: "Alpha", city: "Potsdam"),
            User(name: "Bravo", city: "Potsdam"),
            User(name: "Charlie", city: "Potsdam"),
            User(name: "Delta", city: "Potsdam")
        ]
        let predicate: (User) -> Bool = { $0.name == "Blob" }
        let keyPath = \User.city
        let newValue = "Berlin"
        let expectedResponseList = originalList

        // when
        let newList = originalList.updateElement(where: predicate, keyPath: keyPath, value: newValue)

        // then
        XCTAssertEqual(expectedResponseList, newList)
    }

    func testUpdateElementUsingKeypathSingleChange() {
        // given
        let originalList = [
            User(name: "Alpha", city: "Potsdam"),
            User(name: "Bravo", city: "Potsdam"),
            User(name: "Blob", city: "Potsdam"),
            User(name: "Charlie", city: "Potsdam"),
            User(name: "Delta", city: "Potsdam")
        ]
        let predicate: (User) -> Bool = { $0.name == "Blob" }
        let keyPath = \User.city
        let newValue = "Berlin"
        let expectedResponseList = [
            User(name: "Alpha", city: "Potsdam"),
            User(name: "Bravo", city: "Potsdam"),
            User(name: "Blob", city: "Berlin"),
            User(name: "Charlie", city: "Potsdam"),
            User(name: "Delta", city: "Potsdam")
        ]

        // when
        let newList = originalList.updateElement(where: predicate, keyPath: keyPath, value: newValue)

        // then
        XCTAssertEqual(expectedResponseList, newList)
    }

    func testUpdateElementUsingKeypathMultipleChanges() {
        // given
        let originalList = [
            User(name: "Alpha", city: "Potsdam"),
            User(name: "Bravo", city: "Potsdam"),
            User(name: "Blob", city: "Potsdam"),
            User(name: "Charlie", city: "Potsdam"),
            User(name: "Delta", city: "Potsdam")
        ]
        let predicate: (User) -> Bool = { ["B", "D"].contains($0.name.first) }
        let keyPath = \User.city
        let newValue = "Berlin"
        let expectedResponseList = [
            User(name: "Alpha", city: "Potsdam"),
            User(name: "Bravo", city: "Berlin"),
            User(name: "Blob", city: "Berlin"),
            User(name: "Charlie", city: "Potsdam"),
            User(name: "Delta", city: "Berlin")
        ]

        // when
        let newList = originalList.updateElement(where: predicate, keyPath: keyPath, value: newValue)

        // then
        XCTAssertEqual(expectedResponseList, newList)
    }

    func testUpdateElementUsingClosureEmptyArray() {
        // given
        let originalList = [User]()
        let predicate: (User) -> Bool = { $0.name == "Blob" }
        let newValue = "Berlin"
        let expectedResponseList = [User]()

        // when
        let newList = originalList.updateElement(where: predicate) {
            $0.city = newValue
        }

        // then
        XCTAssertEqual(expectedResponseList, newList)
    }

    func testUpdateElementUsingClosureNoChanges() {
        // given
        let originalList = [
            User(name: "Alpha", city: "Potsdam"),
            User(name: "Bravo", city: "Potsdam"),
            User(name: "Charlie", city: "Potsdam"),
            User(name: "Delta", city: "Potsdam")
        ]
        let predicate: (User) -> Bool = { $0.name == "Blob" }
        let newValue = "Berlin"
        let expectedResponseList = originalList

        // when
        let newList = originalList.updateElement(where: predicate) {
            $0.city = newValue
        }

        // then
        XCTAssertEqual(expectedResponseList, newList)
    }

    func testUpdateElementUsingClosureSingleChange() {
        // given
        let originalList = [
            User(name: "Alpha", city: "Potsdam"),
            User(name: "Bravo", city: "Potsdam"),
            User(name: "Blob", city: "Potsdam"),
            User(name: "Charlie", city: "Potsdam"),
            User(name: "Delta", city: "Potsdam")
        ]
        let predicate: (User) -> Bool = { $0.name == "Blob" }
        let newValue = "Berlin"
        let expectedResponseList = [
            User(name: "Alpha", city: "Potsdam"),
            User(name: "Bravo", city: "Potsdam"),
            User(name: "Blob", city: "Berlin"),
            User(name: "Charlie", city: "Potsdam"),
            User(name: "Delta", city: "Potsdam")
        ]

        // when
        let newList = originalList.updateElement(where: predicate) {
            $0.city = newValue
        }

        // then
        XCTAssertEqual(expectedResponseList, newList)
    }

    func testUpdateElementUsingClosureMultipleChanges() {
        // given
        let originalList = [
            User(name: "Alpha", city: "Potsdam"),
            User(name: "Bravo", city: "Potsdam"),
            User(name: "Blob", city: "Potsdam"),
            User(name: "Charlie", city: "Potsdam"),
            User(name: "Delta", city: "Potsdam")
        ]
        let predicate: (User) -> Bool = { ["B", "D"].contains($0.name.first) }
        let newValue = "Berlin"
        let expectedResponseList = [
            User(name: "Alpha", city: "Potsdam"),
            User(name: "Bravo", city: "Berlin"),
            User(name: "Blob", city: "Berlin"),
            User(name: "Charlie", city: "Potsdam"),
            User(name: "Delta", city: "Berlin")
        ]

        // when
        let newList = originalList.updateElement(where: predicate) {
            $0.city = newValue
        }

        // then
        XCTAssertEqual(expectedResponseList, newList)
    }
}

extension CollectionExtensionTests {
    func testSafeSubcriptGetSuccess() {
        // given
        let array = [1, 2, 3, 4]

        // when
        let sut = array[safe: 2]

        // then
        XCTAssertEqual(3, sut)
    }

    func testSafeSubcriptSetSuccess() {
        // given
        var array = [1, 2, 3, 4]

        // when
        array[safe: 2] = 42

        // then
        XCTAssertEqual([1, 2, 42, 4], array)
    }

    func testSafeSubcriptGetNegative() {
        // given
        let array = [1, 2, 3, 4]

        // when
        let sut = array[safe: -2]

        // then
        XCTAssertNil(sut)
    }

    func testSafeSubcriptSetNegative() {
        // given
        var array = [1, 2, 3, 4]

        // when
        array[safe: -2] = 42

        // then
        XCTAssertEqual([1, 2, 3, 4], array)
    }

    func testSafeSubcriptGetOutOfBounds() {
        // given
        let array = [1, 2, 3, 4]

        // when
        let sut = array[safe: 4]

        // then
        XCTAssertNil(sut)
    }

    func testSafeSubcriptSetOutOfBounds() {
        // given
        var array = [1, 2, 3, 4]

        // when
        array[safe: 4] = 42

        // then
        XCTAssertEqual([1, 2, 3, 4], array)
    }

    func testRemoveSafeSubcriptSuccess() {
        // given
        var array = [1, 2, 3, 4]

        // when
        let sut = array.removeSafe(at: 2)

        // then
        XCTAssertEqual([1, 2, 4], array)
        XCTAssertEqual(3, sut)
    }

    func testRemoveSafeSubcriptNegative() {
        // given
        var array = [1, 2, 3, 4]

        // when
        let sut = array.removeSafe(at: -2)

        // then
        XCTAssertEqual([1, 2, 3, 4], array)
        XCTAssertNil(sut)
    }

    func testRemoveSafeSubcriptOutOfBounds() {
        // given
        var array = [1, 2, 3, 4]

        // when
        let sut = array.removeSafe(at: 4)

        // then
        XCTAssertEqual([1, 2, 3, 4], array)
        XCTAssertNil(sut)
    }
}
#endif
