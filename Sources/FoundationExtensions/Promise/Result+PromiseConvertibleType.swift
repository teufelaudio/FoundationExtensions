//
//  Result+PromiseConvertibleType.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 29.05.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

#if canImport(Combine)
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Result: PromiseConvertibleType {
    public typealias Output = Success
    public typealias Failure = Failure

    /// A Promise is a Publisher that lives in between First and Deferred.
    /// It will listen to one and only one event, and finish successfully, or finish with error without any successful output.
    /// It will hang until an event arrives from upstream. If the upstream is eager, it will be deferred, that means it won't
    /// be created (therefore, no side-effect possible) until the downstream sends demand (`.demand > .none`). This, of course,
    /// if it was not created yet before passed to this initializer.
    /// That way, you can safely add `Future` as upstream, for example, and be sure that its side-effect won't be started. The
    /// behaviour, then, will be similar to `Deferred<Future<Output, Failure>>`, however with some extra features such as better
    /// zips, and a run function to easily start the effect. The cancellation is possible and will be forwarded to the upstream
    /// if the effect had already started.
    /// This property will create a Promise that, upon subscription and `demand > .none` will emit success or failure, depending
    /// on this `Result` instance.
    public func promise() -> Publishers.Promise<Success, Failure> {
        Publishers.Promise(result: self)
    }

    /// A Promise is a Publisher that lives in between First and Deferred.
    /// It will listen to one and only one event, and finish successfully, or finish with error without any successful output.
    /// It will hang until an event arrives from upstream. If the upstream is eager, it will be deferred, that means it won't
    /// be created (therefore, no side-effect possible) until the downstream sends demand (`.demand > .none`). This, of course,
    /// if it was not created yet before passed to this initializer.
    /// That way, you can safely add `Future` as upstream, for example, and be sure that its side-effect won't be started. The
    /// behaviour, then, will be similar to `Deferred<Future<Output, Failure>>`, however with some extra features such as better
    /// zips, and a run function to easily start the effect. The cancellation is possible and will be forwarded to the upstream
    /// if the effect had already started.
    /// This property will create a Promise that, upon subscription and `demand > .none` will emit success or failure, depending
    /// on this `Result` instance.
    public func promise<T: Error>() -> Publishers.Promise<Success, Failure> where Failure == PromiseError<T> {
        Publishers.Promise(result: self)
    }
}
#endif
