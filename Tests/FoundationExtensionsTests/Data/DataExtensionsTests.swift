// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

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

    func testDataFromHexString() {
        let sut = Data(hex: "6949efc9cf1a68a772af811bca5250bb744aac7c")!
        XCTAssertEqual(sut, Data([0x69, 0x49, 0xef, 0xc9,
                                  0xcf, 0x1a, 0x68, 0xa7,
                                  0x72, 0xaf, 0x81, 0x1b,
                                  0xca, 0x52, 0x50, 0xbb,
                                  0x74, 0x4a, 0xac, 0x7c]))
    }
}
#endif
