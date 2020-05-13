//
//  Optional+Traverse.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 30.11.18.
//  Copyright © 2018 Lautsprecher Teufel GmbH. All rights reserved.
//

import Combine
import Foundation

extension Optional {
    public func traverse<A>(_ transform: (Wrapped) -> [A]) -> [A?] {
        switch self {
        case let value?:
            return transform(value)
        case .none:
            return [nil]
        }
    }

    public func traverse<A>(_ transform: (Wrapped) -> A?) -> A?? {
        return map(transform)
    }

    public func traverse<A, Failure>(_ transform: (Wrapped) -> Result<A, Failure>) -> Result<A?, Failure> {
        return map { value in
            return transform(value).map { $0 as A? }
        } ?? .success(nil)
    }
}
