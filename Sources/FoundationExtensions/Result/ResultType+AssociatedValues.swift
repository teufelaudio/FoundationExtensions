//
//  ResultType+AssociatedValues.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 30.11.18.
//  Copyright © 2018 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

// MARK: - Prism
extension ResultType {
    /// Possible value, or nil
    public var value: Success? {
        return fold(onSuccess: { $0 as Success? },
                    onFailure: { _ in nil })
    }

    /// Possible error, or nil
    public var error: Failure? {
        return fold(onSuccess: { _ in nil },
                    onFailure: identity)
    }

    /// True if the result has a wrapped value
    public var isSuccess: Bool {
        return fold(onSuccess: { _ in true },
                    onFailure: { _ in false })
    }

    /// True if the result has a wrapped error
    public var isFailure: Bool {
        return !isSuccess
    }
}
