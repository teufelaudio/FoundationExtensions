// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation
import FoundationExtensions
import XCTest

class TypePathConvertibleTests: XCTestCase {

    func testTypePath() {
        // given
        enum A: TypePathConvertible {
            enum B: TypePathConvertible {
                case foo
                case bar

                enum C: TypePathConvertible {
                    case yik
                    case yak
                }
            }
        }
        let sut = A.B.C.yak

        // when
        let result = sut.typePath

        // then
        XCTAssertEqual(result, "FoundationExtensionsTests.TypePathConvertibleTests.A.B.C.yak")
    }
}
