//
//  Publishers+PrependLatest.swift
//  FoundationExtensions
//
//  Created by Thomas Mellenthin on 22.07.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

#if canImport(Combine)
import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.CombineLatest {
    public func prependLatest<P: Publisher>(_ publisher: P) -> AnyPublisher<Output, Failure> where P.Output == Output, P.Failure == Failure {
        publisher.flatMap { left, right in
            Publishers.CombineLatest(
                self.a.prepend(left),
                self.b.prepend(right)
            )
        }
        .eraseToAnyPublisher()
    }
}
#endif
