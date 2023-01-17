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

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
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

    public struct CombineLatest6<A, B, C, D, E, F>: Publisher where A: Publisher,
                                                                 B: Publisher,
                                                                 C: Publisher,
                                                                 D: Publisher,
                                                                 E: Publisher,
                                                                 F: Publisher,
                                                                 A.Failure == B.Failure,
                                                                 B.Failure == C.Failure,
                                                                 C.Failure == D.Failure,
                                                                 D.Failure == E.Failure,
                                                                 E.Failure == F.Failure{
        public typealias Output = (A.Output, B.Output, C.Output, D.Output, E.Output, F.Output)
        public typealias Failure = A.Failure

        let a: A
        let b: B
        let c: C
        let d: D
        let e: E
        let f: F

        public init(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F) {
            self.a = a
            self.b = b
            self.c = c
            self.d = d
            self.e = e
            self.f = f
        }

        public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            Publishers.CombineLatest(Publishers.CombineLatest5(a, b, c, d, e), f)
                .map { (abcdeTuple, fOutput) in
                    (abcdeTuple.0, abcdeTuple.1, abcdeTuple.2, abcdeTuple.3, abcdeTuple.4, fOutput)
                }
                .receive(subscriber: subscriber)
        }
    }
    
    public struct CombineLatest7<A, B, C, D, E, F, G>: Publisher where A: Publisher,
                                                                       B: Publisher,
                                                                       C: Publisher,
                                                                       D: Publisher,
                                                                       E: Publisher,
                                                                       F: Publisher,
                                                                       G: Publisher,
                                                                       A.Failure == B.Failure,
                                                                       B.Failure == C.Failure,
                                                                       C.Failure == D.Failure,
                                                                       D.Failure == E.Failure,
                                                                       E.Failure == F.Failure,
                                                                       F.Failure == G.Failure{
        public typealias Output = (A.Output, B.Output, C.Output, D.Output, E.Output, F.Output, G.Output)
        public typealias Failure = A.Failure

        let a: A
        let b: B
        let c: C
        let d: D
        let e: E
        let f: F
        let g: G

        public init(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G) {
            self.a = a
            self.b = b
            self.c = c
            self.d = d
            self.e = e
            self.f = f
            self.g = g
        }

        public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            Publishers.CombineLatest(Publishers.CombineLatest6(a, b, c, d, e, f), g)
                .map { (abcdefTuple, gOutput) in
                    (abcdefTuple.0, abcdefTuple.1, abcdefTuple.2, abcdefTuple.3, abcdefTuple.4, abcdefTuple.5, gOutput)
                }
                .receive(subscriber: subscriber)
        }
    }
}

#endif
