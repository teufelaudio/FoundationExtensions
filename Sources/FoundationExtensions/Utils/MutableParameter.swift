//  Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

/// MutableParameter is a way to represent thing that are in change.
/// Like, imagine that the headphones name is "avocado". Now we want to change it to "orange".
/// In the headphones is still "avocado", but the user wants "orange", we are sending the request but while we
/// don't get the ack confirming that the change was applied, this information is still unreliable.
/// If we say the name is "orange", it's wrong, because the headphones disagrees on that. If we say the name
/// is "avocado" we lose the information about the requested change.
/// So the MutableParameter state machine is
/// .value("avocado") -> .changing(old: "avocado", new: "orange") -> if success .value("orange") else if failure .value("avocado").
/// This is very useful for UISwitch and UISlider bindings, where we want to show the optimistic value ("orange")
/// to avoid UI glitches.
/// For bigger structures we can show a UIActivitityIndicator when MutableParameter is .changing and not .value. This makes it very flexible.
public enum MutableParameter<T> {
    case value(T)
    case changing(old: T, new: T)

    public func requestChange(to newValue: T) -> MutableParameter<T> {
        return .changing(old: pessimisticValue, new: newValue)
    }

    public mutating func requestChangeMutating(to newValue: T) {
        self = self.requestChange(to: newValue)
    }

    public var optimisticValue: T {
        switch self {
        case let .changing(_, new): return new
        case let .value(value): return value
        }
    }

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

// MARK: - MutableParameter - EnumCodable
extension MutableParameter: Codable where T: Codable {
    enum CodingKeys: String, CodingKey {
        case type
        case associatedValues

        enum ValueKeys: String, CodingKey {
            case associatedValue0
        }
        enum ChangingKeys: String, CodingKey {
            case old
            case new
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(String.self, forKey: .type) {
        case "value":
            let subContainer = try container.nestedContainer(keyedBy: CodingKeys.ValueKeys.self, forKey: .associatedValues)
            let associatedValues0 = try subContainer.decode(T.self, forKey: .associatedValue0)
            self = .value(associatedValues0)
        case "changing":
            let subContainer = try container.nestedContainer(keyedBy: CodingKeys.ChangingKeys.self, forKey: .associatedValues)
            let associatedValues0 = try subContainer.decode(T.self, forKey: .old)
            let associatedValues1 = try subContainer.decode(T.self, forKey: .new)
            self = .changing(old: associatedValues0, new: associatedValues1)
        default:
            throw DecodingError.keyNotFound(CodingKeys.type, .init(codingPath: container.codingPath, debugDescription: "Unknown key"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .value(associatedValue0):
            try container.encode("value", forKey: .type)
            var subContainer = container.nestedContainer(keyedBy: CodingKeys.ValueKeys.self, forKey: .associatedValues)
            try subContainer.encode(associatedValue0, forKey: .associatedValue0)
        case let .changing(old, new):
            try container.encode("changing", forKey: .type)
            var subContainer = container.nestedContainer(keyedBy: CodingKeys.ChangingKeys.self, forKey: .associatedValues)
            try subContainer.encode(old, forKey: .old)
            try subContainer.encode(new, forKey: .new)
        }
    }
}

// MARK: - MutableParameter - Prism
extension MutableParameter {
    public var value: T? {
        get {
            guard case let .value(associatedValue0) = self else { return nil }
            return (associatedValue0)
        }
        set {
            guard case .value = self, let newValue = newValue else { return }
            self = .value(newValue)
        }
    }

    public var isValue: Bool {
        self.value != nil
    }

    public var changing: (old: T, new: T)? {
        get {
            guard case let .changing(old, new) = self else { return nil }
            return (old, new)
        }
        set {
            guard case .changing = self, let newValue = newValue else { return }
            self = .changing(old: newValue.0, new: newValue.1)
        }
    }

    public var isChanging: Bool {
        self.changing != nil
    }

}
