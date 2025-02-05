// Copyright © 2024 Lautsprecher Teufel GmbH. All rights reserved.

#if !os(watchOS)
import FoundationExtensions
import XCTest

class DataMatchesTests: XCTestCase {
    
    func testExactMatchWithFullMask() {
        // Test case where the data matches the expected exactly, with a full mask.
        let testData = Data([0b10101010, 0b11001100, 0b11110000])
        let expected = Data([0b10101010, 0b11001100, 0b11110000])
        let mask = Data([0xFF, 0xFF, 0xFF])  // Full mask
        let matchMask = Data.MatchMask(expected: expected, mask: mask)

        XCTAssertTrue(testData.matches(matchMask), "The data should match the expected bytes with a full mask.")
    }

    func testPartialMaskMatch() {
        // Test case where the data matches the expected with a partial mask.
        let testData = Data([0b10101010, 0b11001110, 0b11110000])
        let expected = Data([0b10101010, 0b11001111, 0b11110000])
        let mask = Data([0xFF, 0xFE, 0xFF])  // Ignore the last bit of the second byte
        let matchMask = Data.MatchMask(expected: expected, mask: mask)

        XCTAssertTrue(testData.matches(matchMask), "The data should match the expected bytes with a partial mask applied.")
    }

    func testNoMaskProvided() {
        // Test case where no mask is provided; should use a full mask by default.
        let testData = Data([0b10101010, 0b11001100, 0b11110000])
        let expected = Data([0b10101010, 0b11001100, 0b11110000])
        let matchMask = Data.MatchMask(expected: expected)  // No mask provided

        XCTAssertTrue(testData.matches(matchMask), "The data should match the expected bytes when no mask is provided, using a full mask by default.")
    }

    func testShortMaskProvided() {
        // Test case where a shorter mask is provided; should fill with 0xFF.
        let testData = Data([0b10101010, 0b11001100, 0b11110000])
        let expected = Data([0b10101010, 0b11001100, 0b11110000])
        let mask = Data([0xFF, 0xFE])  // Shorter mask provided
        let matchMask = Data.MatchMask(expected: expected, mask: mask)

        XCTAssertTrue(testData.matches(matchMask), "The data should match the expected bytes when a shorter mask is provided, filling the rest with 0xFF.")
    }

    func testMismatchedData() {
        // Test case where the data does not match the expected bytes.
        let testData = Data([0b10101010, 0b11001100, 0b11110000])
        let expected = Data([0b10101010, 0b11111111, 0b11110000])
        let mask = Data([0xFF, 0xFF, 0xFF])  // Full mask
        let matchMask = Data.MatchMask(expected: expected, mask: mask)

        XCTAssertFalse(testData.matches(matchMask), "The data should not match the expected bytes with a full mask.")
    }

    func testAllBitsMasked() {
        // Test case where all bits are masked (mask is 0x00 for all bytes).
        let testData = Data([0b10101010, 0b11001100, 0b11110000])
        let expected = Data([0b00000000, 0b00000000, 0b00000000])
        let mask = Data([0x00, 0x00, 0x00])  // All bits are masked
        let matchMask = Data.MatchMask(expected: expected, mask: mask)

        XCTAssertTrue(testData.matches(matchMask), "The data should match regardless of the bytes when all bits are masked.")
    }

    func testEmptyDataAndMask() {
        // Test case where both data and mask are empty.
        let testData = Data()
        let expected = Data()
        let matchMask = Data.MatchMask(expected: expected)  // No mask provided

        XCTAssertTrue(testData.matches(matchMask), "Empty data should match empty expected data with no mask provided.")
    }

    func testEmptyDataWithNonEmptyExpected() {
        // Test case where data is empty but expected is not.
        let testData = Data()
        let expected = Data([0b10101010])
        let matchMask = Data.MatchMask(expected: expected)  // No mask provided

        XCTAssertFalse(testData.matches(matchMask), "Empty data should not match non-empty expected data.")
    }

    func testNonEmptyDataWithEmptyExpected() {
        // Test case where expected is empty but data is not.
        let testData = Data([0b10101010])
        let expected = Data()
        let matchMask = Data.MatchMask(expected: expected)  // No mask provided

        XCTAssertFalse(testData.matches(matchMask), "Non-empty data should not match empty expected data.")
    }
    
    func testDescription() {
        let data     = Data([0b10101010, 0b10111011, 0b11001100, 0b11110000]) // 0xaabbccf0
        let expected = Data([0b10101010, 0b10111011, 0b11001101, 0b11110000]) // 0xaabbcdf0
        let mask     = Data([0b00000000, 0b11111111, 0b11111110])             // 0xfffffe   - Only 3 bytes provided, third byte misses last bit (0xfe)
        let matchMask = Data.MatchMask(expected: expected, mask: mask)

        XCTAssertTrue(data.matches(matchMask))
        XCTAssertEqual(matchMask.description, "0x**bb··f0")
    }
}

#endif

