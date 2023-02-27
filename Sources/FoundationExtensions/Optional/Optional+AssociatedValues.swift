// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

extension Optional {

    /// Returns true if optional has value
    public var isSome: Bool {
        return fold(onSome: { _ in true },
                    onNone: { false })
    }

    /// Returns true if optional is nil
    public var isNone: Bool {
        return !isSome
    }
}
