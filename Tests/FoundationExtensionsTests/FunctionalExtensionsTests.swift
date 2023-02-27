// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if !os(watchOS)
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

    func testMutateForMultipleProperties() {
        // given
        struct MutableValue: Equatable {
            var value1: String = ""
            var value2: Int = 0
            var value3: Date = .init(timeIntervalSince1970: 100)
        }
        let immutableValue: MutableValue = .init()
        let expectedValue: MutableValue = .init(value1: "TestResult",
                                                value2: 999,
                                                value3: .init(timeIntervalSince1970: 9999))

        // when
        let mutatedVersionOfValue = mutate(root: immutableValue) {
            $0.value1 = "TestResult"
            $0.value2 = 999
            $0.value3 = .init(timeIntervalSince1970: 9999)
        }

        // then
        XCTAssertEqual(expectedValue, mutatedVersionOfValue)
    }

    func testMutateForOneProperty() {
        // given
        struct MutableValue: Equatable {
            var value1: String = ""
            var value2: Int = 0
            var value3: Date = .init(timeIntervalSince1970: 100)
        }
        let immutableValue: MutableValue = .init()
        let expectedValue: MutableValue = .init(value1: "",
                                                value2: 15,
                                                value3: .init(timeIntervalSince1970: 100))

        // when
        let mutatedVersionOfValue = mutate(root: immutableValue,
                                           with: 15,
                                           for: \.value2)

        // then
        XCTAssertEqual(expectedValue, mutatedVersionOfValue)
    }
}
#endif
