// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

//#if !os(watchOS)
import FoundationExtensions
import XCTest

class StringExtensionsTests: XCTestCase {
    func testGivenErrorWhenEncodingItEncodesErrorAsString() {
        let foo = FooType(name: "FooFoo", lastFuckUp: .didntLookCrossingRoad)

        let encoder = JSONEncoder()
        let encodedFoo = try? encoder.encode(foo)
        
        guard let encodedFoo else {
            XCTFail("Unable to encode FooType!")
            return
        }
        
        let encodedFooString = String(data: encodedFoo, encoding: .utf8)
        
        XCTAssertEqual(encodedFooString, "{\"name\":\"FooFoo\",\"lastFuckUp\":{\"didntLookCrossingRoad\":{}}}")
    }
}

fileprivate struct FooType: Codable {
    let name: String
    let lastFuckUp: FooTypeError
}

extension FooType {
    enum FooTypeError: Error, Codable {
        case didntLookCrossingRoad
    }
}
//#endif
