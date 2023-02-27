// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

extension DispatchTimeInterval {
    public func toTimeInterval() -> TimeInterval? {
        switch self {
        case .never: return nil
        case let .seconds(value): return TimeInterval(value)
        case let .milliseconds(value): return TimeInterval(value) / 1e3
        case let .microseconds(value): return TimeInterval(value) / 1e6
        case let .nanoseconds(value): return TimeInterval(value) / 1e9

        @unknown default: return nil
        }
    }

    public static func fromTimeInterval(_ value: TimeInterval?) -> DispatchTimeInterval {
        guard let value = value else { return .never }

        let inSeconds = value
        if inSeconds ≅ inSeconds.rounded() ± 1e-10 {
            return .seconds(Int(inSeconds))
        }

        let inMilliseconds = inSeconds * 1e3
        if inMilliseconds ≅ inMilliseconds.rounded() ± 1e-7 {
            return .milliseconds(Int(inMilliseconds))
        }

        let inMicroseconds = inMilliseconds * 1e3
        if inMicroseconds ≅ inMicroseconds.rounded() ± 1e-4 {
            return .microseconds(Int(inMicroseconds))
        }

        let inNanoseconds = inMicroseconds * 1e3
        return .nanoseconds(Int(inNanoseconds))
    }
}
