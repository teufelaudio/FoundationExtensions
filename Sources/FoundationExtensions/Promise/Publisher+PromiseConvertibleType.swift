//
//  Publisher+PromiseConvertibleType.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 29.05.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

#if canImport(Combine)
import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension NonEmptyPublisher: PromiseConvertibleType {
    /// A Promise is a Publisher that lives in between First and Deferred.
    /// It will listen to one and only one event, and finish successfully, or finish with error without any successful output.
    /// It will hang until an event arrives from this upstream.
    /// Calling it from `promise` property on the instance, means that this publisher was already created and can't be deferred
    /// anymore. If you want to profit from lazy evaluation of Promise it's recommended to use the `Promise.init(Publisher)`,
    /// that uses a closures to create the publisher and makes it lazy until the downstream sends demand (`.demand > .none`).
    /// That way, you can safely add `Future` as upstream, for example, and be sure that its side-effect won't be started. The
    /// behaviour, then, will be similar to `Deferred<Future<Output, Failure>>`, however with some extra features such as better
    /// zips, and a run function to easily start the effect. The cancellation is possible and will be forwarded to the upstream
    /// if the effect had already started.
    public var promise: Publishers.Promise<Output, Failure> {
        Publishers.Promise { self }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
    /// A Promise is a Publisher that lives in between First and Deferred.
    /// It will listen to one and only one event, and finish successfully, or finish with error without any successful output.
    /// It will hang until an event arrives from this upstream.
    /// Calling it from `promise` property on the instance, means that this publisher was already created and can't be deferred
    /// anymore. If you want to profit from lazy evaluation of Promise it's recommended to use the `Promise.init(Publisher)`,
    /// that uses a closures to create the publisher and makes it lazy until the downstream sends demand (`.demand > .none`).
    /// That way, you can safely add `Future` as upstream, for example, and be sure that its side-effect won't be started. The
    /// behaviour, then, will be similar to `Deferred<Future<Output, Failure>>`, however with some extra features such as better
    /// zips, and a run function to easily start the effect. The cancellation is possible and will be forwarded to the upstream
    /// if the effect had already started.
    public func promise(onEmpty fallback: @escaping () -> Result<Output, Failure>) -> Publishers.Promise<Output, Failure> {
        self.nonEmpty(fallback: fallback).promise
    }

    public func assertNonEmptyPromise() -> Publishers.Promise<Output, Failure> {
        NonEmptyPublisher.unsafe(nonEmptyUpstream: self).promise
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Just: PromiseConvertibleType {
    public var promise: Publishers.Promise<Output, Failure> {
        Publishers.Promise.unsafe { self }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Fail: PromiseConvertibleType {
    public var promise: Publishers.Promise<Output, Failure> {
        Publishers.Promise.unsafe { self }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Result: PromiseConvertibleType {
    public var promise: Publishers.Promise<Success, Failure> {
        Publishers.Promise(result: self)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.ReplaceEmpty: PromiseConvertibleType {
    public var promise: Publishers.Promise<Output, Failure> {
        Publishers.Promise.unsafe { self }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Result.Publisher: PromiseConvertibleType {
    public var promise: Publishers.Promise<Success, Failure> {
        Publishers.Promise.unsafe { self }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Future: PromiseConvertibleType {
    public var promise: Publishers.Promise<Output, Failure> {
        Publishers.Promise.unsafe { self }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension URLSession.DataTaskPublisher {
    public var promise: Publishers.Promise<Output, Failure> {
        Publishers.Promise.unsafe { self }
    }
}
#endif
