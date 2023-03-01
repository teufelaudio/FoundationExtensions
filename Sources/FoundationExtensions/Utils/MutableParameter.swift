//  Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

/// MutableParameter is a way of representing things that can change their value, where it takes some time for the changes to take effect.
///
/// For example, imagine the name of a device is "avocado". Changing it over a slow connection takes time, and until confirmation is received the name is in an intermediate state:
///
///     .value("avocado") -> .changing(old: "avocado", new: "orange")
/// When confirmation of the rename command is received, either the change (success) should be applied or reverted to the previous value (error).
///
///     if success { .value("orange") } else { .value("avocado") }
/// This is very useful for UI bindings where the optimistic value ("orange") should be shown to avoid UI glitches, or when the MutableParameter .changes an ActivityIndicator is shown.
// sourcery: Prism
// sourcery: EnumCodable
public enum MutableParameter<T> {
    case value(T)
    case changing(old: T, new: T)

    public func requestChange(to newValue: T) -> MutableParameter<T> {
        return .changing(old: pessimisticValue, new: newValue)
    }

    public mutating func requestChangeMutating(to newValue: T) {
        self = self.requestChange(to: newValue)
    }

    /// - Returns: The current value or the new one.
    public var optimisticValue: T {
        switch self {
        case let .changing(_, new): return new
        case let .value(value): return value
        }
    }

    /// - Returns: The current value or the old one.
    public var pessimisticValue: T {
        switch self {
        case let .changing(old, _): return old
        case let .value(value): return value
        }
    }
}

extension MutableParameter: Equatable where T: Equatable { }
extension MutableParameter: Hashable where T: Hashable { }
extension MutableParameter: Sendable where T: Sendable { }
