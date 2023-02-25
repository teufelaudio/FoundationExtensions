// sourcery: Prism
// sourcery: EnumCodable
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
extension MutableParameter: Encodable where T: Encodable { }
extension MutableParameter: Decodable where T: Decodable { }
