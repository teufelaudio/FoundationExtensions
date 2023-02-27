// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if !os(watchOS)
import FoundationExtensions
import XCTest

class OptionalExtensionTests: XCTestCase {
    func testIsSomeTrue() {
        // given
        let optional: Int? = 42

        // when
        let sut = optional.isSome

        // then
        XCTAssertTrue(sut)
    }

    func testIsSomeFalse() {
        // given
        let optional: Int? = nil

        // when
        let sut = optional.isSome

        // then
        XCTAssertFalse(sut)
    }

    func testIsNoneTrue() {
        // given
        let optional: Int? = nil

        // when
        let sut = optional.isNone

        // then
        XCTAssertTrue(sut)
    }

    func testIsNoneFalse() {
        // given
        let optional: Int? = 42

        // when
        let sut = optional.isNone

        // then
        XCTAssertFalse(sut)
    }
}

extension OptionalExtensionTests {
    func testArrayIsNilOrEmptyFalse() {
        // given
        let array: [Int]? = [3]

        // when
        let sut = array.isNilOrEmpty

        // then
        XCTAssertFalse(sut)
    }

    func testArrayIsNilOrEmptyTrueBecauseIsEmpty() {
        // given
        let array: [Int]? = []

        // when
        let sut = array.isNilOrEmpty

        // then
        XCTAssertTrue(sut)
    }

    func testArrayIsNilOrEmptyTrueBecauseIsNil() {
        // given
        let array: [Int]? = nil

        // when
        let sut = array.isNilOrEmpty

        // then
        XCTAssertTrue(sut)
    }
}

extension OptionalExtensionTests {
    func testApply() {
        // given
        // This is the example on documentation
        let five: Int? = 5
        let none: Int? = nil
        let doubleMe: ((Int) -> Int)? = { $0 * 2 }
        let doubleMeNil: ((Int) -> Int)? = nil
        let expectedFiveDoubleMe: Int? = 10
        let expectedNoneDoubleMe: Int? = nil
        let expectedFiveDoubleMeNil: Int? = nil
        let expectedNoneDoubleMeNil: Int? = nil

        // when
        let fiveDoubleMe = five.apply(doubleMe)
        let noneDoubleMe = none.apply(doubleMe)
        let fiveDoubleMeNil = five.apply(doubleMeNil)
        let noneDoubleMeNil = none.apply(doubleMeNil)

        // then
        XCTAssertEqual(expectedFiveDoubleMe, fiveDoubleMe)
        XCTAssertEqual(expectedNoneDoubleMe, noneDoubleMe)
        XCTAssertEqual(expectedFiveDoubleMeNil, fiveDoubleMeNil)
        XCTAssertEqual(expectedNoneDoubleMeNil, noneDoubleMeNil)
    }

    func testLift() {
        // given
        // This is the example on documentation
        let stringify = Int?.lift(String.init)
        let optionalOne: Int? = 1
        let optionalTwo: Int? = 2
        let optionalNil: Int? = nil
        let expectedOptionalOneResult: String? = "1"
        let expectedOptionalTwoResult: String? = "2"
        let expectedOptionalNilResult: String? = nil

        // when
        let optionalOneResult = stringify(optionalOne)
        let optionalTwoResult = stringify(optionalTwo)
        let optionalNilResult = stringify(optionalNil)

        // then
        XCTAssertEqual(expectedOptionalOneResult, optionalOneResult)
        XCTAssertEqual(expectedOptionalTwoResult, optionalTwoResult)
        XCTAssertEqual(expectedOptionalNilResult, optionalNilResult)
    }

    func testFlattenSome() {
        // given
        // This is the example on documentation
        let nestedOptional: Int?? = 2
        let expectedResult: Int? = 2

        // when
        let sut = nestedOptional.flatten()

        // then
        XCTAssertEqual(expectedResult, sut)
    }

    func testFlattenOuterNil() {
        // given
        // This is the example on documentation
        let nestedOptional: Int?? = Optional<Int?>.none
        let expectedResult: Int? = nil

        // when
        let sut = nestedOptional.flatten()

        // then
        XCTAssertEqual(expectedResult, sut)
    }

    func testFlattenInnerNil() {
        // given
        // This is the example on documentation
        let nestedOptional: Int?? = Int??.some(Int?.none)
        let expectedResult: Int? = nil

        // when
        let sut = nestedOptional.flatten()

        // then
        XCTAssertEqual(expectedResult, sut)
    }

    func testFilterSuccess() {
        // given
        let optional: Int? = 4
        let isEven: (Int) -> Bool = { $0 % 2 == 0 }
        let expectedResult: Int? = 4

        // when
        let sut = optional.filter(isEven)

        // then
        XCTAssertEqual(expectedResult, sut)
    }

    func testFilterFalseBecauseItWasNil() {
        // given
        let optional: Int? = nil
        let isEven: (Int) -> Bool = { $0 % 2 == 0 }

        // when
        let sut = optional.filter(isEven)

        // then
        XCTAssertNil(sut)
    }

    func testFilterFalseBecauseItWasFalse() {
        // given
        let optional: Int? = 5
        let isEven: (Int) -> Bool = { $0 % 2 == 0 }

        // when
        let sut = optional.filter(isEven)

        // then
        XCTAssertNil(sut)
    }

    func testToResultSuccess() {
        // given
        let optional: Int? = 42
        let error = AnyError()
        let expectedResult: Result<Int, AnyError> = .success(42)

        // when
        let sut = optional.toResult(orError: error)

        // then
        XCTAssertEqual(expectedResult, sut)
    }

    func testToResultFailure() {
        // given
        let optional: Int? = nil
        let error = AnyError()
        let expectedResult: Result<Int, AnyError> = .failure(error)

        // when
        let sut = optional.toResult(orError: error)

        // then
        XCTAssertEqual(expectedResult, sut)
    }

    func testNilOutIfEmptyWhenStringIsEmptyReturnsNil() {
        // given
        let optional: String? = ""
        let expectedResult: String? = nil

        // when
        let sut = optional?.nilOutIfEmpty

        // then
        XCTAssertEqual(expectedResult, sut)
    }

    func testNilOutIfEmptyWhenStringIsNotEmptyReturnsString() {
        // given
        let optional: String? = "abc"
        let expectedResult: String? = "abc"

        // when
        let sut = optional?.nilOutIfEmpty

        // then
        XCTAssertEqual(expectedResult, sut)
    }

    func testNilOutIfEmptyWhenStringIsNilReturnsNil() {
        // given
        let optional: String? = nil
        let expectedResult: String? = nil

        // when
        let sut = optional?.nilOutIfEmpty

        // then
        XCTAssertEqual(expectedResult, sut)
    }
}
#endif
