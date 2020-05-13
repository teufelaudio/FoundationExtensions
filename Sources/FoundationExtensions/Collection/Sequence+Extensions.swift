//
//  Sequence+Extensions.swift
//  FoundationExtensions
//
//  Created by Thomas Mellenthin on 28.01.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

extension Sequence where Element == UInt8 {
    public func hex(withPrefix: Bool = true) -> [String] {
        return self.map { "\(withPrefix ? "0x" : "")\(String($0, radix: 16, uppercase: true).leftPadding(toLength: 2, withPad: "0"))" }
    }

    public func hexString(withPrefix: Bool = true) -> String {
        let string = self.map { String($0, radix: 16, uppercase: false).leftPadding(toLength: 2, withPad: "0") }.joined()
        return "\(withPrefix ? "0x" : "")\(string)"
    }
}
