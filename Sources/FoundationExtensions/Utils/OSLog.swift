//  Copyright © 2025 Lautsprecher Teufel GmbH. All rights reserved.

import OSLog

extension OSLog {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "FoundationExtensions"

    /// All logs related to tracking and analytics.
    @usableFromInline
    static let publishersPromise = OSLog(subsystem: subsystem, category: "Publishers.Promise")
}
