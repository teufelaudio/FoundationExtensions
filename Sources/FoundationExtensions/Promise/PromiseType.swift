//
//  PromiseType.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 11.01.19.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

#if canImport(Combine)
import Combine
import Foundation

/// Any type or protocol that can be converted into `Promise<Success, Failure>`
/// Used for type erasure.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol PromiseType: PromiseConvertibleType, Publisher where Success == Output {
    /// A promise from an upstream publisher. Because this is an closure parameter, the upstream will become a factory
    /// and its creation will be deferred until there's some positive demand from the downstream.
    /// - Parameter upstream: a closure that creates an upstream publisher. This is an closure, so creation will be deferred.
    init<P: Publisher>(_ upstream: @escaping () -> NonEmptyPublisher<P>) where P.Output == Success, P.Failure == Failure
}
#endif
