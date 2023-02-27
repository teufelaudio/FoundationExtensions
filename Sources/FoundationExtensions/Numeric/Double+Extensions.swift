// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

extension Double: SignedStringConvertible {
    public var signedDescription: String? { NSNumber(value: self).signedDescription }
}
