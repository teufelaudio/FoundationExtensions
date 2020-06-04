//
//  DispatchTimeInterval+Prism.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 30.04.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

extension DispatchTimeInterval {
    public var seconds: Int? {
        get {
            guard case let .seconds(associatedValue0) = self else { return nil }
            return (associatedValue0)
        }
        set {
            guard case .seconds = self, let newValue = newValue else { return }
            self = .seconds(newValue)
        }
    }

    public var isSeconds: Bool {
        self.seconds != nil
    }

    public var milliseconds: Int? {
        get {
            guard case let .milliseconds(associatedValue0) = self else { return nil }
            return (associatedValue0)
        }
        set {
            guard case .milliseconds = self, let newValue = newValue else { return }
            self = .milliseconds(newValue)
        }
    }

    public var isMilliseconds: Bool {
        self.milliseconds != nil
    }

    public var microseconds: Int? {
        get {
            guard case let .microseconds(associatedValue0) = self else { return nil }
            return (associatedValue0)
        }
        set {
            guard case .microseconds = self, let newValue = newValue else { return }
            self = .microseconds(newValue)
        }
    }

    public var isMicroseconds: Bool {
        self.microseconds != nil
    }

    public var nanoseconds: Int? {
        get {
            guard case let .nanoseconds(associatedValue0) = self else { return nil }
            return (associatedValue0)
        }
        set {
            guard case .nanoseconds = self, let newValue = newValue else { return }
            self = .nanoseconds(newValue)
        }
    }

    public var isNanoseconds: Bool {
        self.nanoseconds != nil
    }

    public var never: Void? {
        guard case .never = self else { return nil }
        return ()
    }

    public var isNever: Bool {
        self.never != nil
    }

}
