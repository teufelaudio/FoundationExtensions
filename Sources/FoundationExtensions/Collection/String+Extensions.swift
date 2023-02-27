// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

extension String {
    public func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return self
        }
    }
}

extension String {
    /// - Returns: `nil` if `isEmpty` is `true`, else returns `String`.
    public var nilOutIfEmpty: Self? {
        isEmpty ? nil : self
    }
}
