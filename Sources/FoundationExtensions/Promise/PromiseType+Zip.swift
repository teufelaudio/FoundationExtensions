//
//  PromiseType+Zip.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 29.05.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

#if canImport(Combine)
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension PromiseType {
    /// Zips two promises in a promise. The upstream results will be paired into a tuple once all of them emit their values.
    /// This is useful for calling async operations in parallel, creating a race that waits for the slowest
    /// one, so all of them will complete, be combined in a tuple and then forwarded to the downstream.
    /// - Parameters:
    ///   - p1: first promise
    ///   - p2: second promise
    /// - Returns: a new promise that will complete when all upstreams gave their results and they were combined into a tuple
    public static func zip<P1: PromiseType, P2: PromiseType>(
        _ p1: P1,
        _ p2: P2
    ) -> Publishers.Promise<(P1.Output, P2.Output), Failure>
    where P1.Failure == Failure, P2.Failure == Failure,
          Output == (P1.Output, P2.Output) {
        Publishers.Promise.unsafe {
            Publishers.Zip(p1, p2)
        }
    }

    /// Zips three promises in a promise. The upstream results will be paired into a tuple once all of them emit their values.
    /// This is useful for calling async operations in parallel, creating a race that waits for the slowest
    /// one, so all of them will complete, be combined in a tuple and then forwarded to the downstream.
    /// - Parameters:
    ///   - p1: first promise
    ///   - p2: second promise
    ///   - p3: third promise
    /// - Returns: a new promise that will complete when all upstreams gave their results and they were combined into a tuple
    public static func zip<P1: PromiseType, P2: PromiseType, P3: PromiseType>(
        _ p1: P1,
        _ p2: P2,
        _ p3: P3
    ) -> Publishers.Promise<(P1.Output, P2.Output, P3.Output), Failure>
    where P1.Failure == Failure, P2.Failure == Failure, P3.Failure == Failure,
          Output == (P1.Output, P2.Output, P3.Output) {
        Publishers.Promise.unsafe {
            Publishers.Zip3(p1, p2, p3)
        }
    }

    /// Zips four promises in a promise. The upstream results will be paired into a tuple once all of them emit their values.
    /// This is useful for calling async operations in parallel, creating a race that waits for the slowest
    /// one, so all of them will complete, be combined in a tuple and then forwarded to the downstream.
    /// - Parameters:
    ///   - p1: first promise
    ///   - p2: second promise
    ///   - p3: third promise
    ///   - p4: fourth promise
    /// - Returns: a new promise that will complete when all upstreams gave their results and they were combined into a tuple
    public static func zip<P1: PromiseType, P2: PromiseType, P3: PromiseType, P4: PromiseType>(
        _ p1: P1,
        _ p2: P2,
        _ p3: P3,
        _ p4: P4
    ) -> Publishers.Promise<(P1.Output, P2.Output, P3.Output, P4.Output), Failure>
    where P1.Failure == Failure, P2.Failure == Failure, P3.Failure == Failure, P4.Failure == Failure,
          Output == (P1.Output, P2.Output, P3.Output, P4.Output) {
        Publishers.Promise.unsafe {
            Publishers.Zip4(p1, p2, p3, p4)
        }
    }

    /// Zips five promises in a promise. The upstream results will be paired into a tuple once all of them emit their values.
    /// This is useful for calling async operations in parallel, creating a race that waits for the slowest
    /// one, so all of them will complete, be combined in a tuple and then forwarded to the downstream.
    /// - Parameters:
    ///   - p1: first promise
    ///   - p2: second promise
    ///   - p3: third promise
    ///   - p4: fourth promise
    ///   - p5: fifth promise
    /// - Returns: a new promise that will complete when all upstreams gave their results and they were combined into a tuple
    public static func zip<P1: PromiseType, P2: PromiseType, P3: PromiseType, P4: PromiseType, P5: PromiseType>(
        _ p1: P1,
        _ p2: P2,
        _ p3: P3,
        _ p4: P4,
        _ p5: P5
    ) -> Publishers.Promise<(P1.Output, P2.Output, P3.Output, P4.Output, P5.Output), Failure>
    where P1.Failure == Failure, P2.Failure == Failure, P3.Failure == Failure, P4.Failure == Failure, P5.Failure == Failure,
          Output == (P1.Output, P2.Output, P3.Output, P4.Output, P5.Output) {
        Publishers.Promise.unsafe {
            Publishers.Zip(
                Publishers.Zip4(p1, p2, p3, p4),
                p5
            )
            .map { left, right in (left.0, left.1, left.2, left.3, right) }
        }
    }

    /// Zips six promises in a promise. The upstream results will be paired into a tuple once all of them emit their values.
    /// This is useful for calling async operations in parallel, creating a race that waits for the slowest
    /// one, so all of them will complete, be combined in a tuple and then forwarded to the downstream.
    /// - Parameters:
    ///   - p1: first promise
    ///   - p2: second promise
    ///   - p3: third promise
    ///   - p4: fourth promise
    ///   - p5: fifth promise
    ///   - p6: sixth promise
    /// - Returns: a new promise that will complete when all upstreams gave their results and they were combined into a tuple
    public static func zip<P1: PromiseType, P2: PromiseType, P3: PromiseType, P4: PromiseType, P5: PromiseType, P6: PromiseType>(
        _ p1: P1,
        _ p2: P2,
        _ p3: P3,
        _ p4: P4,
        _ p5: P5,
        _ p6: P6
    ) -> Publishers.Promise<(P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output), Failure>
    where P1.Failure == Failure, P2.Failure == Failure, P3.Failure == Failure, P4.Failure == Failure, P5.Failure == Failure, P6.Failure == Failure,
          Output == (P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output) {
        Publishers.Promise.unsafe {
            Publishers.Zip(
                Publishers.Zip4(p1, p2, p3, p4),
                Publishers.Zip(p5, p6)
            )
            .map { left, right in (left.0, left.1, left.2, left.3, right.0, right.1) }
        }
    }

    /// Zips seven promises in a promise. The upstream results will be paired into a tuple once all of them emit their values.
    /// This is useful for calling async operations in parallel, creating a race that waits for the slowest
    /// one, so all of them will complete, be combined in a tuple and then forwarded to the downstream.
    /// - Parameters:
    ///   - p1: first promise
    ///   - p2: second promise
    ///   - p3: third promise
    ///   - p4: fourth promise
    ///   - p5: fifth promise
    ///   - p6: sixth promise
    ///   - p7: seventh promise
    /// - Returns: a new promise that will complete when all upstreams gave their results and they were combined into a tuple
    public static func zip<P1: PromiseType, P2: PromiseType, P3: PromiseType, P4: PromiseType, P5: PromiseType, P6: PromiseType, P7: PromiseType>(
        _ p1: P1,
        _ p2: P2,
        _ p3: P3,
        _ p4: P4,
        _ p5: P5,
        _ p6: P6,
        _ p7: P7
    ) -> Publishers.Promise<(P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output, P7.Output), Failure>
    where P1.Failure == Failure, P2.Failure == Failure, P3.Failure == Failure, P4.Failure == Failure, P5.Failure == Failure, P6.Failure == Failure,
          P7.Failure == Failure,
          Output == (P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output, P7.Output) {
        Publishers.Promise.unsafe {
            Publishers.Zip(
                Publishers.Zip4(p1, p2, p3, p4),
                Publishers.Zip3(p5, p6, p7)
            )
            .map { left, right in (left.0, left.1, left.2, left.3, right.0, right.1, right.2) }
        }
    }

    /// Zips eight promises in a promise. The upstream results will be paired into a tuple once all of them emit their values.
    /// This is useful for calling async operations in parallel, creating a race that waits for the slowest
    /// one, so all of them will complete, be combined in a tuple and then forwarded to the downstream.
    /// - Parameters:
    ///   - p1: first promise
    ///   - p2: second promise
    ///   - p3: third promise
    ///   - p4: fourth promise
    ///   - p5: fifth promise
    ///   - p6: sixth promise
    ///   - p7: seventh promise
    ///   - p8: eighth promise
    /// - Returns: a new promise that will complete when all upstreams gave their results and they were combined into a tuple
    public static func zip<P1: PromiseType, P2: PromiseType, P3: PromiseType, P4: PromiseType, P5: PromiseType, P6: PromiseType, P7: PromiseType,
                           P8: PromiseType> (
        _ p1: P1,
        _ p2: P2,
        _ p3: P3,
        _ p4: P4,
        _ p5: P5,
        _ p6: P6,
        _ p7: P7,
        _ p8: P8
    ) -> Publishers.Promise<(P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output, P7.Output, P8.Output), Failure>
    where P1.Failure == Failure, P2.Failure == Failure, P3.Failure == Failure, P4.Failure == Failure, P5.Failure == Failure, P6.Failure == Failure,
          P7.Failure == Failure, P8.Failure == Failure,
          Output == (P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output, P7.Output, P8.Output) {
        Publishers.Promise.unsafe {
            Publishers.Zip(
                Publishers.Zip4(p1, p2, p3, p4),
                Publishers.Zip4(p5, p6, p7, p8)
            )
            .map { left, right in (left.0, left.1, left.2, left.3, right.0, right.1, right.2, right.3) }
        }
    }

    /// Zips nine promises in a promise. The upstream results will be paired into a tuple once all of them emit their values.
    /// This is useful for calling async operations in parallel, creating a race that waits for the slowest
    /// one, so all of them will complete, be combined in a tuple and then forwarded to the downstream.
    /// - Parameters:
    ///   - p1: first promise
    ///   - p2: second promise
    ///   - p3: third promise
    ///   - p4: fourth promise
    ///   - p5: fifth promise
    ///   - p6: sixth promise
    ///   - p7: seventh promise
    ///   - p8: eighth promise
    ///   - p9: ninth promise
    /// - Returns: a new promise that will complete when all upstreams gave their results and they were combined into a tuple
    public static func zip<P1: PromiseType, P2: PromiseType, P3: PromiseType, P4: PromiseType, P5: PromiseType, P6: PromiseType, P7: PromiseType,
                           P8: PromiseType, P9: PromiseType> (
        _ p1: P1,
        _ p2: P2,
        _ p3: P3,
        _ p4: P4,
        _ p5: P5,
        _ p6: P6,
        _ p7: P7,
        _ p8: P8,
        _ p9: P9
    ) -> Publishers.Promise<(P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output, P7.Output, P8.Output, P9.Output), Failure>
    where P1.Failure == Failure, P2.Failure == Failure, P3.Failure == Failure, P4.Failure == Failure, P5.Failure == Failure, P6.Failure == Failure,
          P7.Failure == Failure, P8.Failure == Failure, P9.Failure == Failure,
          Output == (P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output, P7.Output, P8.Output, P9.Output) {
        Publishers.Promise.unsafe {
            Publishers.Zip3(
                Publishers.Zip4(p1, p2, p3, p4),
                Publishers.Zip4(p5, p6, p7, p8),
                p9
            )
            .map { left, center, right in (left.0, left.1, left.2, left.3, center.0, center.1, center.2, center.3, right) }
        }
    }

    /// Zips ten promises in a promise. The upstream results will be paired into a tuple once all of them emit their values.
    /// This is useful for calling async operations in parallel, creating a race that waits for the slowest
    /// one, so all of them will complete, be combined in a tuple and then forwarded to the downstream.
    /// - Parameters:
    ///   - p1: first promise
    ///   - p2: second promise
    ///   - p3: third promise
    ///   - p4: fourth promise
    ///   - p5: fifth promise
    ///   - p6: sixth promise
    ///   - p7: seventh promise
    ///   - p8: eighth promise
    ///   - p9: ninth promise
    ///   - p10: tenth promise
    /// - Returns: a new promise that will complete when all upstreams gave their results and they were combined into a tuple
    public static func zip<P1: PromiseType, P2: PromiseType, P3: PromiseType, P4: PromiseType, P5: PromiseType, P6: PromiseType, P7: PromiseType,
                           P8: PromiseType, P9: PromiseType, P10: PromiseType> (
        _ p1: P1,
        _ p2: P2,
        _ p3: P3,
        _ p4: P4,
        _ p5: P5,
        _ p6: P6,
        _ p7: P7,
        _ p8: P8,
        _ p9: P9,
        _ p10: P10
    ) -> Publishers.Promise<(P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output, P7.Output, P8.Output, P9.Output, P10.Output), Failure>
    where P1.Failure == Failure, P2.Failure == Failure, P3.Failure == Failure, P4.Failure == Failure, P5.Failure == Failure, P6.Failure == Failure,
          P7.Failure == Failure, P8.Failure == Failure, P9.Failure == Failure, P10.Failure == Failure,
          Output == (P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output, P7.Output, P8.Output, P9.Output, P10.Output) {
        Publishers.Promise.unsafe {
            Publishers.Zip3(
                Publishers.Zip4(p1, p2, p3, p4),
                Publishers.Zip4(p5, p6, p7, p8),
                Publishers.Zip(p9, p10)
            )
            .map { left, center, right in (left.0, left.1, left.2, left.3, center.0, center.1, center.2, center.3, right.0, right.1) }
        }
    }

    /// Zips eleven promises in a promise. The upstream results will be paired into a tuple once all of them emit their values.
    /// This is useful for calling async operations in parallel, creating a race that waits for the slowest
    /// one, so all of them will complete, be combined in a tuple and then forwarded to the downstream.
    /// - Parameters:
    ///   - p1: first promise
    ///   - p2: second promise
    ///   - p3: third promise
    ///   - p4: fourth promise
    ///   - p5: fifth promise
    ///   - p6: sixth promise
    ///   - p7: seventh promise
    ///   - p8: eighth promise
    ///   - p9: ninth promise
    ///   - p10: tenth promise
    ///   - p11: eleventh promise
    /// - Returns: a new promise that will complete when all upstreams gave their results and they were combined into a tuple
    public static func zip < P1: PromiseType, P2: PromiseType, P3: PromiseType, P4: PromiseType, P5: PromiseType, P6: PromiseType, P7: PromiseType,
                           P8: PromiseType, P9: PromiseType, P10: PromiseType, P11: PromiseType > (
        _ p1: P1,
        _ p2: P2,
        _ p3: P3,
        _ p4: P4,
        _ p5: P5,
        _ p6: P6,
        _ p7: P7,
        _ p8: P8,
        _ p9: P9,
        _ p10: P10,
        _ p11: P11
    ) -> Publishers.Promise<(P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output, P7.Output, P8.Output, P9.Output, P10.Output,
                             P11.Output), Failure>
    where P1.Failure == Failure, P2.Failure == Failure, P3.Failure == Failure, P4.Failure == Failure, P5.Failure == Failure, P6.Failure == Failure,
          P7.Failure == Failure, P8.Failure == Failure, P9.Failure == Failure, P10.Failure == Failure, P11.Failure == Failure,
          Output == (P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output, P7.Output, P8.Output, P9.Output, P10.Output, P11.Output) {
        Publishers.Promise.unsafe {
            Publishers.Zip3(
                Publishers.Zip4(p1, p2, p3, p4),
                Publishers.Zip4(p5, p6, p7, p8),
                Publishers.Zip3(p9, p10, p11)
            )
            .map { left, center, right in (left.0, left.1, left.2, left.3, center.0, center.1, center.2, center.3, right.0, right.1, right.2) }
        }
    }

    /// Zips twelve promises in a promise. The upstream results will be paired into a tuple once all of them emit their values.
    /// This is useful for calling async operations in parallel, creating a race that waits for the slowest
    /// one, so all of them will complete, be combined in a tuple and then forwarded to the downstream.
    /// - Parameters:
    ///   - p1: first promise
    ///   - p2: second promise
    ///   - p3: third promise
    ///   - p4: fourth promise
    ///   - p5: fifth promise
    ///   - p6: sixth promise
    ///   - p7: seventh promise
    ///   - p8: eighth promise
    ///   - p9: ninth promise
    ///   - p10: tenth promise
    ///   - p11: eleventh promise
    ///   - p12: twelfth promise
    /// - Returns: a new promise that will complete when all upstreams gave their results and they were combined into a tuple
    public static func zip<P1: PromiseType, P2: PromiseType, P3: PromiseType, P4: PromiseType, P5: PromiseType, P6: PromiseType, P7: PromiseType,
                           P8: PromiseType, P9: PromiseType, P10: PromiseType, P11: PromiseType, P12: PromiseType> (
        _ p1: P1,
        _ p2: P2,
        _ p3: P3,
        _ p4: P4,
        _ p5: P5,
        _ p6: P6,
        _ p7: P7,
        _ p8: P8,
        _ p9: P9,
        _ p10: P10,
        _ p11: P11,
        _ p12: P12
    ) -> Publishers.Promise<(P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output, P7.Output, P8.Output, P9.Output, P10.Output, P11.Output,
                             P12.Output), Failure>
    where P1.Failure == Failure, P2.Failure == Failure, P3.Failure == Failure, P4.Failure == Failure, P5.Failure == Failure, P6.Failure == Failure,
          P7.Failure == Failure, P8.Failure == Failure, P9.Failure == Failure, P10.Failure == Failure, P11.Failure == Failure,
          P12.Failure == Failure,
          Output == (P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output, P7.Output, P8.Output, P9.Output, P10.Output, P11.Output,
                     P12.Output) {
        Publishers.Promise.unsafe {
            Publishers.Zip3(
                Publishers.Zip4(p1, p2, p3, p4),
                Publishers.Zip4(p5, p6, p7, p8),
                Publishers.Zip4(p9, p10, p11, p12)
            )
            .map { left, center, right in
                (left.0, left.1, left.2, left.3, center.0, center.1, center.2, center.3, right.0, right.1, right.2, right.3)
            }
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
    public static func zip<P: PromiseType>(_ promises: [P]) -> Publishers.Promise<[P.Output], P.Failure>
    where P.Output == Output, P.Failure == Failure {
        switch promises.count {
        case ...0:
            return .init(value: [])
        case 1:
            return promises[0].map { [$0] }
        default:
            let result: Publishers.Promise<[P.Output], P.Failure> = promises[0].map { [$0] }

            return promises.dropFirst().reduce(result) { partial, current -> Publishers.Promise<[P.Output], P.Failure> in
                Publishers.Promise.zip(
                    partial,
                    current
                )
                .map { accumulation, next in accumulation + [next] }
            }
        }
    }
}
#endif
