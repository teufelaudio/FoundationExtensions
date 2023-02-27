// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

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

extension CollectionExtensionTests {
    func testSplitArrayInChunks() {
        // given
        let array = Array(100...113)

        // when
        let sut = array.split(maxSize: 4)

        // then
        XCTAssertEqual(sut.count, 4)

        // First chunk
        XCTAssertEqual(sut[0].count, 4)
        XCTAssertTrue(sut[0].elementsEqual([100, 101, 102, 103]))

        // Second chunk
        XCTAssertEqual(sut[1].count, 4)
        XCTAssertTrue(sut[1].elementsEqual([104, 105, 106, 107]))

        // Third chunk
        XCTAssertEqual(sut[2].count, 4)
        XCTAssertTrue(sut[2].elementsEqual([108, 109, 110, 111]))

        // Fourth chunk
        XCTAssertEqual(sut[3].count, 2)
        XCTAssertTrue(sut[3].elementsEqual([112, 113]))
    }

    func testSplitStringInChunks() {
        // given
        //                                                50 ↓                                             100 ↓
        let string = """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore \
            et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut a\
            liquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillu\
            m dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui\
             officia deserunt mollit anim id est laborum.
            """

        // when
        let sut = string.split(maxSize: 50)

        // then
        XCTAssertEqual(sut.count, 9)
        XCTAssertEqual(sut, [
            "Lorem ipsum dolor sit amet, consectetur adipiscing",
            " elit, sed do eiusmod tempor incididunt ut labore ",
            "et dolore magna aliqua. Ut enim ad minim veniam, q",
            "uis nostrud exercitation ullamco laboris nisi ut a",
            "liquip ex ea commodo consequat. Duis aute irure do",
            "lor in reprehenderit in voluptate velit esse cillu",
            "m dolore eu fugiat nulla pariatur. Excepteur sint ",
            "occaecat cupidatat non proident, sunt in culpa qui",
            " officia deserunt mollit anim id est laborum."
        ])
    }

    func testSplitDataInChunks() {
        // given
        let array = Data(0x01...0x12)

        // when
        let sut = array.split(maxSize: 5)

        // then
        XCTAssertEqual(sut.count, 4)

        // First chunk
        XCTAssertEqual(sut[0].count, 5)
        XCTAssertTrue(sut[0].elementsEqual([0x01, 0x02, 0x03, 0x04, 0x05]))

        // Second chunk
        XCTAssertEqual(sut[1].count, 5)
        XCTAssertTrue(sut[1].elementsEqual([0x06, 0x07, 0x08, 0x09, 0x0A]))

        // Third chunk
        XCTAssertEqual(sut[2].count, 5)
        XCTAssertTrue(sut[2].elementsEqual([0x0B, 0x0C, 0x0D, 0x0E, 0x0F]))

        // Fourth chunk
        XCTAssertEqual(sut[3].count, 3)
        XCTAssertTrue(sut[3].elementsEqual([0x10, 0x11, 0x12]))
    }
}

extension CollectionExtensionTests {
    func testMapDetectingLast() {
        // given
        let originalArray = [1, 1, 2, 3, 5, 8, 13, 21, 34]

        // when
        let sut = originalArray.mapDetectingLast { isLast, number in
            "\(isLast ? "[last:" : "[not-last:")\(number)]"
        }

        // then
        XCTAssertEqual(
            [
                "[not-last:1]",
                "[not-last:1]",
                "[not-last:2]",
                "[not-last:3]",
                "[not-last:5]",
                "[not-last:8]",
                "[not-last:13]",
                "[not-last:21]",
                "[last:34]",
            ],
            sut
        )
    }
}
#endif
