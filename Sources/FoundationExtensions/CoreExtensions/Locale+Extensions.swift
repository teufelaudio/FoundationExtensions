// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

extension Locale {
    internal static var getReference: () -> Locale = {
        return .current
    }

    public static var reference: Locale {
        return getReference()
    }

    public static var de: Locale {
        return .init(identifier: "de")
    }

    public static var us: Locale {
        return .init(identifier: "us")
    }

    public static var usPosix: Locale {
        return .init(identifier: "en_US_POSIX")
    }
}
