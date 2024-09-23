// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if !os(watchOS)
import FoundationExtensions
import XCTest

class AnyEncodableTests: XCTestCase {

    // MARK: - String Encoding
    func testStringEncodingInit() {
        // Given
        let encoder = JSONEncoder()
        let testString = "This is a test string to test encoding. \\::: ☝️"

        // When
        let sut = AnyEncodable(testString)

        // Then
        XCTAssertEqual(try? encoder.encode(testString), try? encoder.encode(sut))
    }
    func testStringEncodingHelper() {
        // Given
        let encoder = JSONEncoder()
        let testString = "This is a test string to test encoding. \\::: ☝️"

        // When
        let sut = testString.anyEncodable

        // Then
        XCTAssertEqual(try? encoder.encode(testString), try? encoder.encode(sut))
    }

    // MARK: - Dictionary Encoding
    func testDictionaryEncodingInit() {
        // Given
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let testDictionary: [String: [Int]] = [
            "key1": [1, 5, 10],
            "key2": [5, 292, 2828]
        ]

        // When
        let sut = AnyEncodable(testDictionary)

        // Then
        XCTAssertEqual(try? encoder.encode(testDictionary), try? encoder.encode(sut))
    }
    func testDictionaryEncodingHelper() {
        // Given
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let testDictionary: [String: [Int]] = [
            "key1": [1, 5, 10],
            "key2": [5, 292, 2828]
        ]

        // When
        let sut = testDictionary.anyEncodable

        // Then
        XCTAssertEqual(try? encoder.encode(testDictionary), try? encoder.encode(sut))
    }
}

#endif
