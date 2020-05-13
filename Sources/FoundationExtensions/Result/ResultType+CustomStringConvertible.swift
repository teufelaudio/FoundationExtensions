//
//  ResultType+CustomStringConvertible.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 30.11.18.
//  Copyright © 2018 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

extension Result: CustomStringConvertible where Success: CustomStringConvertible { }

extension ResultType where Success: CustomStringConvertible {
    /// Describes value or error
    public var description: String {
        return fold(onSuccess: { value in
            value.description
        }, onFailure: { error in
            error.localizedDescription
        })
    }
}

extension Result: CustomDebugStringConvertible {
}

extension ResultType {
    /// Describes value or error for debugging
    public var debugDescription: String {
        return fold(onSuccess: { value in
            let string = (value as? CustomDebugStringConvertible)?.debugDescription ?? "\(value)"
            return ".success(\(string))"
        }, onFailure: { error in
            return ".failure(\(error.localizedDescription))"
        })
    }
}
