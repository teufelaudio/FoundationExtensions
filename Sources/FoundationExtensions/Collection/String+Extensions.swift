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

/// Lets String confirm to LocalizedError which implements `errorDescription` returning self.
/// Helps to print or encode `Error` types as strings. See tests.
extension String: LocalizedError {
    public var errorDescription: String? {
        self
    }
}
