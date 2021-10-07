// Copyright © 2021 Lautsprecher Teufel GmbH. All rights reserved.

#if !os(watchOS)
import FoundationExtensions
import XCTest

class DataExtensionsTests: XCTestCase {
    func testDataInRangeSuccessfullyExtractSubdataInTheMiddle() {
        let fullData = Data([0xDE, 0xAD, 0xBE, 0xFF])
        let partialData = fullData.range(start: 1, length: 1)
        XCTAssertEqual(partialData, Data([0xAD]))
    }

    func testDataInRangeSuccessfullyExtractSubdataAtTheEnd() {
        let fullData = Data([0xDE, 0xAD, 0xBE, 0xFF])
        let partialData = fullData.range(start: 3, length: 1)
        XCTAssertEqual(partialData, Data([0xFF]))
    }

    func testDataOutOfRangeBecauseOfLengthABitTooLong() {
        let fullData = Data([0xDE, 0xAD, 0xBE, 0xFF])
        let partialData = fullData.range(start: 3, length: 2)
        XCTAssertEqual(partialData, Data([0xFF]))
    }

    func testDataOutOfRangeBecauseOfLengthWayTooLong() {
        let fullData = Data([0xDE, 0xAD, 0xBE, 0xFF])
        let partialData = fullData.range(start: 1, length: 10)
        XCTAssertEqual(partialData, Data([0xAD, 0xBE, 0xFF]))
    }

    func testDataOutOfRangeBecauseOfStart() {
        let fullData = Data([0xDE, 0xAD, 0xBE, 0xFF])
        let partialData = fullData.range(start: 4, length: 1)
        XCTAssertEqual(partialData, Data([]))
    }
}
#endif
