// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

extension Int: SignedStringConvertible {
    public var signedDescription: String? { NSNumber(value: self).signedDescription }
}
