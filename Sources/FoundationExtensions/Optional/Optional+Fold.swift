//
//  Optional+Fold.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 30.11.18.
//  Copyright © 2018 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

extension Optional {
    public func fold<A>(onSome: (Wrapped) -> A, onNone: () -> A) -> A {
        switch self {
        case .some(let value):
            return onSome(value)
        case .none:
            return onNone()
        }
    }

    @discardableResult
    public func analysis(ifSome: (Wrapped) -> Void, ifNone: () -> Void) -> Optional {
        fold(onSome: ifSome, onNone: ifNone)
        return self
    }
}
