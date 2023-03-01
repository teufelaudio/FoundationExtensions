// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import FoundationExtensions
import XCTest

class MutableParameterTests: XCTestCase {
    func test_MutableParameterRequestChangeTo20_WhenSelfIsValue15_ReturnsChangingFrom15To20() {
        // given
        let input: MutableParameter<Int> = .value(15)

        // when
        let sut = input.requestChange(to: 20)

        // then
        let result: MutableParameter<Int> = .changing(old: 15, new: 20)

        XCTAssertEqual(sut, result)
    }

    func test_MutableParameterRequestChangeMutatingTo20_WhenSelfIsValue15_MutatesSelfToChangingFrom15To20() {
        // given
        var input: MutableParameter<Int> = .value(15)

        // when
        input.requestChangeMutating(to: 20)

        // then
        let result: MutableParameter<Int> = .changing(old: 15, new: 20)

        XCTAssertEqual(input, result)
    }

    func test_MutableParameterSuccessRequest_WhenSelfIsValue15_ReturnsNil() {
        // given
        let input: MutableParameter<Int> = .value(15)

        // when
        let sut = input.successRequest()

        // then
        let result: MutableParameter<Int>? = nil

        XCTAssertEqual(sut, result)
    }

    func test_MutableParameterSuccessRequest_WhenValueIsChangingFrom15To20_ReturnsValue20() {
        // given
        let input: MutableParameter<Int> = .changing(old: 15, new: 20)

        // when
        let sut = input.successRequest()

        // then
        let result: MutableParameter<Int>? = .value(20)

        XCTAssertEqual(sut, result)
    }

    func test_MutableParameterSuccessRequest_MutatingWhenSelfIsValue15_DoesNotMutateAndReturnsNil() {
        // given
        var input: MutableParameter<Int> = .value(15)

        // when
        let sut = input.successRequestMutating()

        // then
        let result: MutableParameter<Int>? = nil

        XCTAssertEqual(input, .value(15))
        XCTAssertEqual(sut, result)
    }

    func test_MutableParameterSuccessRequestMutating_WhenSelfIsChangingFrom15To20_MutatesAndReturnsValue20() {
        // given
        var input: MutableParameter<Int> = .changing(old: 15, new: 20)

        // when
        let sut = input.successRequestMutating()

        // then
        let result: MutableParameter<Int>? = .value(20)

        XCTAssertEqual(sut, input)
        XCTAssertEqual(sut, result)
    }

    func test_MutableParameterFailRequest_WhenSelfIsValue15_ReturnsNil() {
        // given
        let input: MutableParameter<Int> = .value(15)

        // when
        let sut = input.failRequest()

        // then
        let result: MutableParameter<Int>? = nil

        XCTAssertEqual(sut, result)
    }

    func test_MutableParameterFailRequest_WhenSelfIsChangingFrom15To20_ReturnsValue15() {
        // given
        let input: MutableParameter<Int> = .changing(old: 15, new: 20)

        // when
        let sut = input.failRequest()

        // then
        let result: MutableParameter<Int>? = .value(15)

        XCTAssertEqual(sut, result)
    }

    func test_MutableParameterFailRequestMutating_WhenSelfIsValue15_DoesNotMutateAndReturnsNil() {
        // given
        var input: MutableParameter<Int> = .value(15)

        // when
        let sut = input.failRequestMutating()

        // then
        let result: MutableParameter<Int>? = nil

        XCTAssertEqual(input, .value(15))
        XCTAssertEqual(sut, result)
    }

    func test_MutableParameterFailRequestMutating_WhenSelfIsChangingFrom15To20_MutatesAndReturnsValue15() {
        // given
        var input: MutableParameter<Int> = .changing(old: 15, new: 20)

        // when
        let sut = input.failRequestMutating()

        // then
        let result: MutableParameter<Int>? = .value(15)

        XCTAssertEqual(sut, input)
        XCTAssertEqual(sut, result)
    }

    func test_MutableParameterPessimisticValue_WhenSelfIsChangingFrom15To20_Returns15() {
        // given
        let input: MutableParameter<Int> = .changing(old: 15, new: 20)

        // when
        let sut: Int = input.pessimisticValue

        // then
        let result: Int = 15

        XCTAssertEqual(sut, result)
    }

    func test_MutableParameterOptimisticValue_WhenSelfIsChangingFrom15To20_Returns20() {
        // given
        let input: MutableParameter<Int> = .changing(old: 15, new: 20)

        // when
        let sut: Int = input.optimisticValue

        // then
        let result: Int = 20

        XCTAssertEqual(sut, result)
    }

    
}
