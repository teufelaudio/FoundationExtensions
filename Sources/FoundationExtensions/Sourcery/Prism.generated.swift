// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import Foundation
import Combine
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
