//
//  ResultConvertibleType.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 30.11.18.
//  Copyright © 2018 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

/// Any type or protocol that can be converted into `Result<Success, Failure>`
/// Used for type erasure.
public protocol ResultConvertibleType {
    /// A value wrapped in this container when the result is successful
    associatedtype Success

    /// An error wrapped in this container when the result is failure
    associatedtype Failure: Error

    /// Identity, return itself. Necessary for protocol programming.
    func asResult() -> Result<Success, Failure>
}
