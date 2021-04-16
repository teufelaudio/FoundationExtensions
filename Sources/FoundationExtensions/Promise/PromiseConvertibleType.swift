//
//  PromiseConvertibleType.swift
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
public protocol PromiseConvertibleType {
    /// A value wrapped in this container when the promise eventually returns success
    associatedtype Success

    /// An error wrapped in this container when the promise eventually returns a failure
    associatedtype Failure: Error

    /// Identity, return itself. Necessary for protocol programming.
    func promise() -> Publishers.Promise<Success, Failure>

    /// Identity, return itself. Necessary for protocol programming.
    func promise<T: Error>() -> Publishers.Promise<Success, Failure> where Failure == PromiseError<T>
}
#endif
