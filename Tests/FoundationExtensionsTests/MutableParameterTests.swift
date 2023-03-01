// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import FoundationExtensions
import XCTest

class MutableParameterTests: XCTestCase {
    func testMutableParameterRequestChangeTo20WhenValue15ChangingTo20() {
        // given
        let input: MutableParameter<Int> = .value(15)

        // when
        let sut = input.requestChange(to: 20)

        // then
        let result: MutableParameter<Int> = .changing(old: 15, new: 20)

        XCTAssertEqual(sut, result)
    }

    func testMutableParameterRequestChangeMutatingTo20WhenValue15ChangingTo20() {
        // given
        var input: MutableParameter<Int> = .value(15)

        // when
        input.requestChangeMutating(to: 20)

        // then
        let result: MutableParameter<Int> = .changing(old: 15, new: 20)

        XCTAssertEqual(input, result)
    }

    func testMutableParameterSuccessRequestWhenValue15Nil() {
        // given
        let input: MutableParameter<Int> = .value(15)

        // when
        let sut = input.successRequest()

        // then
        let result: MutableParameter<Int>? = nil

        XCTAssertEqual(sut, result)
    }

    func testMutableParameterSuccessRequestWhenChangingFrom15To20Value20() {
        // given
        let input: MutableParameter<Int> = .changing(old: 15, new: 20)

        // when
        let sut = input.successRequest()

        // then
        let result: MutableParameter<Int>? = .value(20)

        XCTAssertEqual(sut, result)
    }

    func testMutableParameterSuccessRequestMutatingWhenValue15Nil() {
        // given
        var input: MutableParameter<Int> = .value(15)

        // when
        let sut = input.successRequestMutating()

        // then
        let result: MutableParameter<Int>? = nil

        XCTAssertEqual(input, .value(15))
        XCTAssertEqual(sut, result)
    }

    func testMutableParameterSuccessRequestMutatingWhenChangingFrom15To20Value20() {
        // given
        var input: MutableParameter<Int> = .changing(old: 15, new: 20)

        // when
        let sut = input.successRequestMutating()

        // then
        let result: MutableParameter<Int>? = .value(20)

        XCTAssertEqual(sut, input)
        XCTAssertEqual(sut, result)
    }

    func testMutableParameterFailRequestWhenValue15Nil() {
        // given
        let input: MutableParameter<Int> = .value(15)

        // when
        let sut = input.failRequest()

        // then
        let result: MutableParameter<Int>? = nil

        XCTAssertEqual(sut, result)
    }

    func testMutableParameterFailRequestWhenChangingFrom15To20Value15() {
        // given
        let input: MutableParameter<Int> = .changing(old: 15, new: 20)

        // when
        let sut = input.failRequest()

        // then
        let result: MutableParameter<Int>? = .value(15)

        XCTAssertEqual(sut, result)
    }

    func testMutableParameterFailRequestMutatingWhenValue15Nil() {
        // given
        var input: MutableParameter<Int> = .value(15)

        // when
        let sut = input.failRequestMutating()

        // then
        let result: MutableParameter<Int>? = nil

        XCTAssertEqual(input, .value(15))
        XCTAssertEqual(sut, result)
    }

    func testMutableParameterFailRequestMutatingWhenChangingFrom15To20Value15() {
        // given
        var input: MutableParameter<Int> = .changing(old: 15, new: 20)

        // when
        let sut = input.failRequestMutating()

        // then
        let result: MutableParameter<Int>? = .value(15)

        XCTAssertEqual(sut, input)
        XCTAssertEqual(sut, result)
    }

    func testMutableParameterPessimisticValueWhenChangingTo20From15PessimisticValue15() {
        // given
        let input: MutableParameter<Int> = .changing(old: 15, new: 20)

        // when
        let sut: Int = input.pessimisticValue

        // then
        let result: Int = 15

        XCTAssertEqual(sut, result)
    }

    func testMutableParameterOptimisticValueWhenChangingTo20From15OptimisticValue20() {
        // given
        let input: MutableParameter<Int> = .changing(old: 15, new: 20)

        // when
        let sut: Int = input.optimisticValue

        // then
        let result: Int = 20

        XCTAssertEqual(sut, result)
    }

    
}
