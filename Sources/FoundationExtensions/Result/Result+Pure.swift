//
//  Result+Pure.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 09.12.19.
//  Copyright © 2019 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

extension Result {
    /// Wraps a pure value in a `Result` container just for the sake of composition, lifting the value to a successful Result
    public func pure(_ value: Success) -> Result {
        Result(value: value)
    }

    /// Wraps a pure value in a `Result` container just for the sake of composition, lifting the value to a successful Result
    public static func pure(_ value: Success) -> Result {
        Result(value: value)
    }
}
