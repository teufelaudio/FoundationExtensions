// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

extension UInt32: SignedStringConvertible {
    public var signedDescription: String? { NSNumber(value: self).signedDescription }
}
