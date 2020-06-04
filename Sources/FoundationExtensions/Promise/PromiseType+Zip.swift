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
    /// Zips two promises in a promise. The upstream results will be merged with the provided map function.
    /// This is useful for calling async operations in parallel, creating a race that waits for the slowest
    /// one, so all of them will complete, be mapped and then forwarded to the downstream.
    /// - Parameters:
    ///   - p1: first promise
    ///   - p2: second promise
    ///   - map: merging all the upstream outputs in the downstream output
    /// - Returns: a new promise that will complete when all upstreams gave their results and the were
    ///            mapped into the downstream output
    public static func zip<P1: PromiseType, P2: PromiseType>(
        _ p1: P1,
        _ p2: P2,
        map: @escaping (P1.Output, P2.Output) -> Output
    ) -> Publishers.Promise<Output, Failure> where P1.Failure == Failure, P2.Failure == Failure {
        Publishers.Promise {
            Publishers.Zip(p1, p2)
                .map(map)
        }
    }

    /// Zips three promises in a promise. The upstream results will be merged with the provided map function.
    /// This is useful for calling async operations in parallel, creating a race that waits for the slowest
    /// one, so all of them will complete, be mapped and then forwarded to the downstream.
    /// - Parameters:
    ///   - p1: first promise
    ///   - p2: second promise
    ///   - p3: third promise
    ///   - map: merging all the upstream outputs in the downstream output
    /// - Returns: a new promise that will complete when all upstreams gave their results and the were
    ///            mapped into the downstream output
    public static func zip<P1: PromiseType, P2: PromiseType, P3: PromiseType>(
        _ p1: P1,
        _ p2: P2,
        _ p3: P3,
        map: @escaping (P1.Output, P2.Output, P3.Output) -> Output
    ) -> Publishers.Promise<Output, Failure> where P1.Failure == Failure, P2.Failure == Failure, P3.Failure == Failure {
        Publishers.Promise {
            Publishers.Zip3(p1, p2, p3)
                .map(map)
        }
    }

    /// Zips four promises in a promise. The upstream results will be merged with the provided map function.
    /// This is useful for calling async operations in parallel, creating a race that waits for the slowest
    /// one, so all of them will complete, be mapped and then forwarded to the downstream.
    /// - Parameters:
    ///   - p1: first promise
    ///   - p2: second promise
    ///   - p3: third promise
    ///   - p4: fourth promise
    ///   - map: merging all the upstream outputs in the downstream output
    /// - Returns: a new promise that will complete when all upstreams gave their results and the were
    ///            mapped into the downstream output
    public static func zip<P1: PromiseType, P2: PromiseType, P3: PromiseType, P4: PromiseType>(
        _ p1: P1,
        _ p2: P2,
        _ p3: P3,
        _ p4: P4,
        map: @escaping (P1.Output, P2.Output, P3.Output, P4.Output) -> Output
    ) -> Publishers.Promise<Output, Failure> where P1.Failure == Failure, P2.Failure == Failure, P3.Failure == Failure, P4.Failure == Failure {
        Publishers.Promise {
            Publishers.Zip4(p1, p2, p3, p4)
                .map(map)
        }
    }

    /// Zips five promises in a promise. The upstream results will be merged with the provided map function.
    /// This is useful for calling async operations in parallel, creating a race that waits for the slowest
    /// one, so all of them will complete, be mapped and then forwarded to the downstream.
    /// - Parameters:
    ///   - p1: first promise
    ///   - p2: second promise
    ///   - p3: third promise
    ///   - p4: fourth promise
    ///   - p5: fifth promise
    ///   - map: merging all the upstream outputs in the downstream output
    /// - Returns: a new promise that will complete when all upstreams gave their results and the were
    ///            mapped into the downstream output
    public static func zip<P1: PromiseType, P2: PromiseType, P3: PromiseType, P4: PromiseType, P5: PromiseType>(
        _ p1: P1,
        _ p2: P2,
        _ p3: P3,
        _ p4: P4,
        _ p5: P5,
        map: @escaping (P1.Output, P2.Output, P3.Output, P4.Output, P5.Output) -> Output
    ) -> Publishers.Promise<Output, Failure> where P1.Failure == Failure, P2.Failure == Failure, P3.Failure == Failure, P4.Failure == Failure,
                                                   P5.Failure == Failure {
        Publishers.Promise {
            Publishers.Zip(
                Publishers.Zip4(p1, p2, p3, p4),
                p5
            )
            .map { tuple -> Output in
                map(tuple.0.0, tuple.0.1, tuple.0.2, tuple.0.3, tuple.1)
            }
        }
    }

    /// Zips six promises in a promise. The upstream results will be merged with the provided map function.
    /// This is useful for calling async operations in parallel, creating a race that waits for the slowest
    /// one, so all of them will complete, be mapped and then forwarded to the downstream.
    /// - Parameters:
    ///   - p1: first promise
    ///   - p2: second promise
    ///   - p3: third promise
    ///   - p4: fourth promise
    ///   - p5: fifth promise
    ///   - p6: sixth promise
    ///   - map: merging all the upstream outputs in the downstream output
    /// - Returns: a new promise that will complete when all upstreams gave their results and the were
    ///            mapped into the downstream output
    public static func zip<P1: PromiseType, P2: PromiseType, P3: PromiseType, P4: PromiseType, P5: PromiseType, P6: PromiseType>(
        _ p1: P1,
        _ p2: P2,
        _ p3: P3,
        _ p4: P4,
        _ p5: P5,
        _ p6: P6,
        map: @escaping (P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output) -> Output
    ) -> Publishers.Promise<Output, Failure> where P1.Failure == Failure, P2.Failure == Failure, P3.Failure == Failure, P4.Failure == Failure,
                                                   P5.Failure == Failure, P6.Failure == Failure {
        Publishers.Promise {
            Publishers.Zip(
                Publishers.Zip4(p1, p2, p3, p4),
                Publishers.Zip(p5, p6)
            )
            .map { tuple -> Output in
                map(tuple.0.0, tuple.0.1, tuple.0.2, tuple.0.3, tuple.1.0, tuple.1.1)
            }
        }
    }

    /// Zips seven promises in a promise. The upstream results will be merged with the provided map function.
    /// This is useful for calling async operations in parallel, creating a race that waits for the slowest
    /// one, so all of them will complete, be mapped and then forwarded to the downstream.
    /// - Parameters:
    ///   - p1: first promise
    ///   - p2: second promise
    ///   - p3: third promise
    ///   - p4: fourth promise
    ///   - p5: fifth promise
    ///   - p6: sixth promise
    ///   - p7: seventh promise
    ///   - map: merging all the upstream outputs in the downstream output
    /// - Returns: a new promise that will complete when all upstreams gave their results and the were
    ///            mapped into the downstream output
    public static func zip<P1: PromiseType, P2: PromiseType, P3: PromiseType, P4: PromiseType, P5: PromiseType, P6: PromiseType, P7: PromiseType>(
        _ p1: P1,
        _ p2: P2,
        _ p3: P3,
        _ p4: P4,
        _ p5: P5,
        _ p6: P6,
        _ p7: P7,
        map: @escaping (P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output, P7.Output) -> Output
    ) -> Publishers.Promise<Output, Failure> where P1.Failure == Failure, P2.Failure == Failure, P3.Failure == Failure, P4.Failure == Failure,
                                                   P5.Failure == Failure, P6.Failure == Failure, P7.Failure == Failure {
        Publishers.Promise {
            Publishers.Zip(
                Publishers.Zip4(p1, p2, p3, p4),
                Publishers.Zip3(p5, p6, p7)
            )
            .map { tuple -> Output in
                map(tuple.0.0, tuple.0.1, tuple.0.2, tuple.0.3, tuple.1.0, tuple.1.1, tuple.1.2)
            }
        }
    }

    /// Zips eight promises in a promise. The upstream results will be merged with the provided map function.
    /// This is useful for calling async operations in parallel, creating a race that waits for the slowest
    /// one, so all of them will complete, be mapped and then forwarded to the downstream.
    /// - Parameters:
    ///   - p1: first promise
    ///   - p2: second promise
    ///   - p3: third promise
    ///   - p4: fourth promise
    ///   - p5: fifth promise
    ///   - p6: sixth promise
    ///   - p7: seventh promise
    ///   - p8: eighth promise
    ///   - map: merging all the upstream outputs in the downstream output
    /// - Returns: a new promise that will complete when all upstreams gave their results and the were
    ///            mapped into the downstream output
    public static func zip < P1: PromiseType, P2: PromiseType, P3: PromiseType, P4: PromiseType, P5: PromiseType, P6: PromiseType, P7: PromiseType,
                           P8: PromiseType > (
        _ p1: P1,
        _ p2: P2,
        _ p3: P3,
        _ p4: P4,
        _ p5: P5,
        _ p6: P6,
        _ p7: P7,
        _ p8: P8,
        map: @escaping (P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output, P7.Output, P8.Output) -> Output
    ) -> Publishers.Promise<Output, Failure> where P1.Failure == Failure, P2.Failure == Failure, P3.Failure == Failure, P4.Failure == Failure,
                                                   P5.Failure == Failure, P6.Failure == Failure, P7.Failure == Failure, P8.Failure == Failure {
        Publishers.Promise {
            Publishers.Zip(
                Publishers.Zip4(p1, p2, p3, p4),
                Publishers.Zip4(p5, p6, p7, p8)
            )
            .map { tuple -> Output in
                map(tuple.0.0, tuple.0.1, tuple.0.2, tuple.0.3, tuple.1.0, tuple.1.1, tuple.1.2, tuple.1.3)
            }
        }
    }

    /// Zips nine promises in a promise. The upstream results will be merged with the provided map function.
    /// This is useful for calling async operations in parallel, creating a race that waits for the slowest
    /// one, so all of them will complete, be mapped and then forwarded to the downstream.
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
    ///   - map: merging all the upstream outputs in the downstream output
    /// - Returns: a new promise that will complete when all upstreams gave their results and the were
    ///            mapped into the downstream output
    public static func zip < P1: PromiseType, P2: PromiseType, P3: PromiseType, P4: PromiseType, P5: PromiseType, P6: PromiseType, P7: PromiseType,
                           P8: PromiseType, P9: PromiseType > (
        _ p1: P1,
        _ p2: P2,
        _ p3: P3,
        _ p4: P4,
        _ p5: P5,
        _ p6: P6,
        _ p7: P7,
        _ p8: P8,
        _ p9: P9,
        map: @escaping (P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output, P7.Output, P8.Output, P9.Output) -> Output
    ) -> Publishers.Promise<Output, Failure> where P1.Failure == Failure, P2.Failure == Failure, P3.Failure == Failure, P4.Failure == Failure,
                                                   P5.Failure == Failure, P6.Failure == Failure, P7.Failure == Failure, P8.Failure == Failure,
                                                   P9.Failure == Failure {
        Publishers.Promise {
            Publishers.Zip3(
                Publishers.Zip4(p1, p2, p3, p4),
                Publishers.Zip4(p5, p6, p7, p8),
                p9
            )
            .map { tuple -> Output in
                map(tuple.0.0, tuple.0.1, tuple.0.2, tuple.0.3, tuple.1.0, tuple.1.1, tuple.1.2, tuple.1.3, tuple.2)
            }
        }
    }

    /// Zips ten promises in a promise. The upstream results will be merged with the provided map function.
    /// This is useful for calling async operations in parallel, creating a race that waits for the slowest
    /// one, so all of them will complete, be mapped and then forwarded to the downstream.
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
    ///   - map: merging all the upstream outputs in the downstream output
    /// - Returns: a new promise that will complete when all upstreams gave their results and the were
    ///            mapped into the downstream output
    public static func zip < P1: PromiseType, P2: PromiseType, P3: PromiseType, P4: PromiseType, P5: PromiseType, P6: PromiseType, P7: PromiseType,
                           P8: PromiseType, P9: PromiseType, P10: PromiseType > (
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
        map: @escaping (P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output, P7.Output, P8.Output, P9.Output, P10.Output) -> Output
    ) -> Publishers.Promise<Output, Failure> where P1.Failure == Failure, P2.Failure == Failure, P3.Failure == Failure, P4.Failure == Failure,
                                                   P5.Failure == Failure, P6.Failure == Failure, P7.Failure == Failure, P8.Failure == Failure,
                                                   P9.Failure == Failure, P10.Failure == Failure {
        Publishers.Promise {
            Publishers.Zip3(
                Publishers.Zip4(p1, p2, p3, p4),
                Publishers.Zip4(p5, p6, p7, p8),
                Publishers.Zip(p9, p10)
            )
            .map { tuple -> Output in
                map(tuple.0.0, tuple.0.1, tuple.0.2, tuple.0.3, tuple.1.0, tuple.1.1, tuple.1.2, tuple.1.3, tuple.2.0, tuple.2.1)
            }
        }
    }

    /// Zips eleven promises in a promise. The upstream results will be merged with the provided map function.
    /// This is useful for calling async operations in parallel, creating a race that waits for the slowest
    /// one, so all of them will complete, be mapped and then forwarded to the downstream.
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
    ///   - map: merging all the upstream outputs in the downstream output
    /// - Returns: a new promise that will complete when all upstreams gave their results and the were
    ///            mapped into the downstream output
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
        _ p11: P11,
        map: @escaping (P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output, P7.Output, P8.Output, P9.Output, P10.Output,
                        P11.Output) -> Output
    ) -> Publishers.Promise<Output, Failure> where P1.Failure == Failure, P2.Failure == Failure, P3.Failure == Failure, P4.Failure == Failure,
                                                   P5.Failure == Failure, P6.Failure == Failure, P7.Failure == Failure, P8.Failure == Failure,
                                                   P9.Failure == Failure, P10.Failure == Failure, P11.Failure == Failure {
        Publishers.Promise {
            Publishers.Zip3(
                Publishers.Zip4(p1, p2, p3, p4),
                Publishers.Zip4(p5, p6, p7, p8),
                Publishers.Zip3(p9, p10, p11)
            )
            .map { tuple -> Output in
                map(tuple.0.0, tuple.0.1, tuple.0.2, tuple.0.3, tuple.1.0, tuple.1.1, tuple.1.2, tuple.1.3, tuple.2.0, tuple.2.1, tuple.2.2)
            }
        }
    }

    /// Zips twelve promises in a promise. The upstream results will be merged with the provided map function.
    /// This is useful for calling async operations in parallel, creating a race that waits for the slowest
    /// one, so all of them will complete, be mapped and then forwarded to the downstream.
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
    ///   - map: merging all the upstream outputs in the downstream output
    /// - Returns: a new promise that will complete when all upstreams gave their results and the were
    ///            mapped into the downstream output
    public static func zip < P1: PromiseType, P2: PromiseType, P3: PromiseType, P4: PromiseType, P5: PromiseType, P6: PromiseType, P7: PromiseType,
                           P8: PromiseType, P9: PromiseType, P10: PromiseType, P11: PromiseType, P12: PromiseType > (
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
        _ p12: P12,
        map: @escaping (P1.Output, P2.Output, P3.Output, P4.Output, P5.Output, P6.Output, P7.Output, P8.Output, P9.Output, P10.Output, P11.Output,
                        P12.Output) -> Output
    ) -> Publishers.Promise<Output, Failure> where P1.Failure == Failure, P2.Failure == Failure, P3.Failure == Failure, P4.Failure == Failure,
                                                   P5.Failure == Failure, P6.Failure == Failure, P7.Failure == Failure, P8.Failure == Failure,
                                                   P9.Failure == Failure, P10.Failure == Failure, P11.Failure == Failure, P12.Failure == Failure {
        Publishers.Promise {
            Publishers.Zip3(
                Publishers.Zip4(p1, p2, p3, p4),
                Publishers.Zip4(p5, p6, p7, p8),
                Publishers.Zip4(p9, p10, p11, p12)
            )
            .map { tuple -> Output in
                map(tuple.0.0, tuple.0.1, tuple.0.2, tuple.0.3, tuple.1.0, tuple.1.1, tuple.1.2, tuple.1.3, tuple.2.0, tuple.2.1, tuple.2.2,
                    tuple.2.3)
            }
        }
    }
}
#endif
