// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if !os(watchOS)
import FoundationExtensions
import XCTest

class DataMD5Tests: XCTestCase {
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func testDataMD5String() throws {
        // given
        let input = "https://www.youtube.com/watch?v=NkAe30aEG5c".data(using: .utf8)!

        // when
        let sut = input.md5String

        // then
        XCTAssertEqual(sut, "ef5ab2d6d6d0a5722d7bfbe06e5a742d")
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func testDataMD5() throws {
        // given
        let input = "https://www.youtube.com/watch?v=quPliK3eAy4".data(using: .utf8)!

        // when
        let sut = input.md5

        // then
        XCTAssertEqual(sut, Data.init([0x43, 0x1b, 0xad, 0x7b, 0x7e, 0xd5, 0x3c, 0xb5, 0xf4, 0x28, 0x33, 0x6c, 0x8b, 0x54, 0x59, 0x41]))
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func testDataMD5Identifier() throws {
        // given
        let input = "https://www.youtube.com/watch?v=_bW4vEo1F4E".data(using: .utf8)!

        // when
        let sut = input.md5Identifier

        // then
        XCTAssertEqual(sut, Data.init([0x3a, 0xe4, 0x08, 0x51]))
    }
}
#endif
