//
//  Reader+Pure.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 09.12.19.
//  Copyright © 2019 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

extension Reader {
    /// Wraps a pure function in a `Reader` container just for the sake of composition. Nothing is actually needed for
    /// the calculation and environment will be ignored
    public func pure(_ value: Value) -> Reader<Environment, Value> {
        .init { _ in
            value
        }
    }

    public static func pure(_ value: Value) -> Reader {
        return Reader { _ in value }
    }
}
