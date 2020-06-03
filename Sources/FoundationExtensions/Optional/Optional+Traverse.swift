//
//  Optional+Traverse.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 30.11.18.
//  Copyright © 2018 Lautsprecher Teufel GmbH. All rights reserved.
//

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
        map(transform)
    }

    public func traverse<A, Failure>(_ transform: (Wrapped) -> Result<A, Failure>) -> Result<A?, Failure> {
        map { value in
            transform(value).map { $0 as A? }
        } ?? .success(nil)
    }

    public func traverse<Environment, A>(_ transform: @escaping (Wrapped) -> Reader<Environment, A>) -> Reader<Environment, A?> {
        Reader { env in
            self.map { value in
                transform(value).inject(env)
            }
        }
    }
}

#if canImport(Combine)
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Optional {
    public func traverse<P: Combine.Publisher>(_ transform: (Wrapped) -> P) -> AnyPublisher<P.Output?, P.Failure> {
        map { value in
            transform(value).map { $0 as P.Output? }.eraseToAnyPublisher()
        } ?? Just<P.Output?>(nil).mapError(absurd).eraseToAnyPublisher()
    }
}
#endif
