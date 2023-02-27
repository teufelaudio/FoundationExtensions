// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

extension Int64: SignedStringConvertible {
    public var signedDescription: String? { NSNumber(value: self).signedDescription }
}
