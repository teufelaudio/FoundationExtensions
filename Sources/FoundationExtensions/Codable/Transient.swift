// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

/// Wraps a value but causes it to be treated as "value-less" for the purposes
/// of automatic Equatable, Hashable, and Codable synthesis. This allows one to
/// declare a "cache"-like property in a value type without giving up the rest
/// of the benefits of synthesis.
public struct Transient<Wrapped>: Equatable, Hashable, Encodable {
    public var value: Wrapped

    public static func == (lhs: Transient<Wrapped>, rhs: Transient<Wrapped>) -> Bool {
        // By always returning true, transient values never produce false negatives
        // that cause two otherwise equal values to become unequal. In other words,
        // they are ignored for the purposes of equality.
        return true
    }

    public func hash(into hasher: inout Hasher) {
        // Transient values do not contribute to the hash value.
    }

    public init(_ value: Wrapped) {
        self.value = value
    }

    public func encode(to encoder: Encoder) throws {
        // Transient properties do not get encoded.
    }
}
