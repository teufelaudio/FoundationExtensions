// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if !os(watchOS)
import FoundationExtensions
import XCTest

class CollectionTraverseTests: XCTestCase {
    func testTraverseArray() {
        // given
        let originalArray = [2, 1, 3]
        let expectedResult = [["2", "2"], ["1"], ["3", "3", "3"]]

        // when
        let sut = originalArray.traverse { Array(repeating: "\($0)", count: $0) }

        // then
        XCTAssertEqual(expectedResult, sut)
    }

    func testTraverseOptionalSuccessful() {
        // given
        let originalArray = ["2", "1", "3"]
        let expectedResult: [Int]? = [2, 1, 3]

        // when
        let sut = originalArray.traverse { NumberFormatter().number(from: $0)?.intValue }

        // then
        XCTAssertEqual(expectedResult, sut)
    }

    func testTraverseOptionalFailure() {
        // given
        let originalArray = ["2", "1", "3", "Oops"]

        // when
        let sut = originalArray.traverse { NumberFormatter().number(from: $0)?.intValue }

        // then
        XCTAssertNil(sut)
    }

    func testTraverseResultSuccessful() {
        // given
        let originalArray = ["2", "1", "3"]
        let expectedResult: Result<[Int], AnyError> = .success([2, 1, 3])

        // when
        let sut = originalArray.traverse { (NumberFormatter().number(from: $0)?.intValue).toResult(orError: AnyError()) }

        // then
        XCTAssertEqual(expectedResult, sut)
    }

    func testTraverseResultFailure() {
        // given
        let error = AnyError()
        let originalArray = ["2", "1", "3", "Oops"]
        let expectedResult: Result<[Int], AnyError> = .failure(error)

        // when
        let sut = originalArray.traverse { (NumberFormatter().number(from: $0)?.intValue).toResult(orError: error) }

        // then
        XCTAssertEqual(expectedResult, sut)
    }
}
#endif
