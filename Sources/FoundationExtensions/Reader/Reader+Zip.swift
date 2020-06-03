//
//  Reader+Zip.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 29.05.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

extension Reader {

    /// Creates a reader that combines multiple readers into one, as long as they depend on same environment. Once this environment is injected,
    /// upstream readers will run and the result will be a tuple containing the resulting values of each upstream reader.
    ///
    /// - Parameters:
    ///   - p1: first reader type
    ///   - p2: second reader type
    /// - Returns: reader that gives a tuple of values after receiving the envinroment
    public static func zip<E, V1, V2>(
        _ p1: Reader<E, V1>,
        _ p2: Reader<E, V2>
    ) -> Reader<E, (V1, V2)> {
        Reader<E, (V1, V2)> { e in
            (p1.inject(e), p2.inject(e))
        }
    }

    /// Creates a reader that combines multiple readers into one, as long as they depend on same environment. Once this environment is injected,
    /// upstream readers will run and the result will be a tuple containing the resulting values of each upstream reader.
    ///
    /// - Parameters:
    ///   - p1: first reader type
    ///   - p2: second reader type
    ///   - p3: third reader type
    /// - Returns: reader that gives a tuple of values after receiving the envinroment
    public static func zip<E, V1, V2, V3>(
        _ p1: Reader<E, V1>,
        _ p2: Reader<E, V2>,
        _ p3: Reader<E, V3>
    ) -> Reader<E, (V1, V2, V3)> {
        Reader<E, (V1, V2, V3)> { e in
            (p1.inject(e), p2.inject(e), p3.inject(e))
        }
    }

    /// Creates a reader that combines multiple readers into one, as long as they depend on same environment. Once this environment is injected,
    /// upstream readers will run and the result will be a tuple containing the resulting values of each upstream reader.
    ///
    /// - Parameters:
    ///   - p1: first reader type
    ///   - p2: second reader type
    ///   - p3: third reader type
    ///   - p4: fourth reader type
    /// - Returns: reader that gives a tuple of values after receiving the envinroment
    public static func zip<E, V1, V2, V3, V4>(
        _ p1: Reader<E, V1>,
        _ p2: Reader<E, V2>,
        _ p3: Reader<E, V3>,
        _ p4: Reader<E, V4>
    ) -> Reader<E, (V1, V2, V3, V4)> {
        Reader<E, (V1, V2, V3, V4)> { e in
            (p1.inject(e), p2.inject(e), p3.inject(e), p4.inject(e))
        }
    }

    /// Creates a reader that combines multiple readers into one, as long as they depend on same environment. Once this environment is injected,
    /// upstream readers will run and the result will be a tuple containing the resulting values of each upstream reader.
    ///
    /// - Parameters:
    ///   - p1: first reader type
    ///   - p2: second reader type
    ///   - p3: third reader type
    ///   - p4: fourth reader type
    ///   - p5: fifth reader type
    /// - Returns: reader that gives a tuple of values after receiving the envinroment
    public static func zip<E, V1, V2, V3, V4, V5>(
        _ p1: Reader<E, V1>,
        _ p2: Reader<E, V2>,
        _ p3: Reader<E, V3>,
        _ p4: Reader<E, V4>,
        _ p5: Reader<E, V5>
    ) -> Reader<E, (V1, V2, V3, V4, V5)> {
        Reader<E, (V1, V2, V3, V4, V5)> { e in
            (p1.inject(e), p2.inject(e), p3.inject(e), p4.inject(e), p5.inject(e))
        }
    }

    /// Creates a reader that combines multiple readers into one, as long as they depend on same environment. Once this environment is injected,
    /// upstream readers will run and the result will be a tuple containing the resulting values of each upstream reader.
    ///
    /// - Parameters:
    ///   - p1: first reader type
    ///   - p2: second reader type
    ///   - p3: third reader type
    ///   - p4: fourth reader type
    ///   - p5: fifth reader type
    ///   - p6: sixth reader type
    /// - Returns: reader that gives a tuple of values after receiving the envinroment
    public static func zip<E, V1, V2, V3, V4, V5, V6>(
        _ p1: Reader<E, V1>,
        _ p2: Reader<E, V2>,
        _ p3: Reader<E, V3>,
        _ p4: Reader<E, V4>,
        _ p5: Reader<E, V5>,
        _ p6: Reader<E, V6>
    ) -> Reader<E, (V1, V2, V3, V4, V5, V6)> {
        Reader<E, (V1, V2, V3, V4, V5, V6)> { e in
            (p1.inject(e), p2.inject(e), p3.inject(e), p4.inject(e), p5.inject(e), p6.inject(e))
        }
    }
}
