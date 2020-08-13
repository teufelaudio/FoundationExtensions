//
//  Publishers+CombineLatest.swift
//  FoundationExtensions
//
//  Created by Thomas Mellenthin on 18.08.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

#if canImport(Combine)
import Foundation
import Combine

@available(iOS 13.0, *)
extension Publishers {
    public struct CombineLatest5<A, B, C, D, E>: Publisher where A: Publisher,
                                                                 B: Publisher,
                                                                 C: Publisher,
                                                                 D: Publisher,
                                                                 E: Publisher,
                                                                 A.Failure == B.Failure,
                                                                 B.Failure == C.Failure,
                                                                 C.Failure == D.Failure,
                                                                 D.Failure == E.Failure {
        public typealias Output = (A.Output, B.Output, C.Output, D.Output, E.Output)
        public typealias Failure = A.Failure

        let a: A
        let b: B
        let c: C
        let d: D
        let e: E

        public init(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E) {
            self.a = a
            self.b = b
            self.c = c
            self.d = d
            self.e = e
        }

        public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            Publishers.CombineLatest(Publishers.CombineLatest4(a, b, c, d), e)
                .map { (abcdTuple, eOutput) in
                    (abcdTuple.0, abcdTuple.1, abcdTuple.2, abcdTuple.3, eOutput)
                }
                .receive(subscriber: subscriber)
        }
    }
}

#endif
