// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

extension UInt: SignedStringConvertible {
    public var signedDescription: String? { NSNumber(value: self).signedDescription }
}
