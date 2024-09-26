// Copyright © 2024 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

@available(iOS 16.0, *)
extension Duration {
    public static func safe(secondsComponent: Int64, attosecondsComponent: Int64) -> Self {
        // Convert attoseconds to seconds (positive or negative)
        let attosecondsInSeconds = attosecondsComponent / 1_000_000_000_000_000_000
        let remainingAttoseconds = attosecondsComponent % 1_000_000_000_000_000_000

        // Check for overflow and underflow
        if secondsComponent >= 0 {
            // Handle positive seconds
            if Int64.max - secondsComponent > attosecondsInSeconds {
                let newSeconds = secondsComponent + attosecondsInSeconds
                return Duration(secondsComponent: newSeconds, attosecondsComponent: remainingAttoseconds)
            } else {
                return Duration(secondsComponent: Int64.max, attosecondsComponent: 0)
            }
        } else {
            // Handle negative seconds
            if Int64.min - secondsComponent < attosecondsInSeconds {
                let newSeconds = secondsComponent + attosecondsInSeconds
                return Duration(secondsComponent: newSeconds, attosecondsComponent: remainingAttoseconds)
            } else {
                return Duration(secondsComponent: Int64.min, attosecondsComponent: 0)
            }
        }
    }

    public static func minutes(_ minutes: Int32) -> Self {
        .seconds(Int64(minutes) * 60)
    }

    public static func hours(_ hours: Int32) -> Self {
        .seconds(Int64(hours) * 60 * 60)
    }
}
