//
//  AggregratedError.swift
//  FoundationExtensions
//
//  Created by Jörg Bühmann on 19.06.19.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

/// Collection of errors that itself conforms to error
/// Useful for collecting multiple errors in a Result or Promise
public struct AggregratedError<ErrorType: Error>: Error {
    public let errors: [ErrorType]

    public init(errors: [ErrorType]) {
        self.errors = errors
    }
}
