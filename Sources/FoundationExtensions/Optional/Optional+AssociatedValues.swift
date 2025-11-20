// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

extension Optional: _OptionalMarker {

    /// Returns true if optional has value
    public var isSome: Bool {
        switch self {
        case .none:
            return false
        case .some(let value):
            // If the wrapped value is another optional, unwrap again
            if let nested = value as? _OptionalMarker {
                return nested.isSome
            }
            return true
        }
    }

    /// Returns true if optional is nil
    public var isNone: Bool {
        return !isSome
    }
}

private protocol _OptionalMarker {
    var isSome: Bool { get }
}
