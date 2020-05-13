//
//  Never+Extensions.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 14.12.18.
//  Copyright © 2018 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

extension Never: Codable {
    /// Never should conform to all possible protocols. Swift team decided to support some protocols only, and only from
    /// Swift 5. https://forums.swift.org/t/se-0215-conform-never-to-equatable-and-hashable/13586/6
    /// Until there, we need at least some protocols to reduce impedance between container types.
    ///
    /// - Parameter decoder: decoder is not expected to try decoding Never.
    /// - Throws: It's certain to throw DecodingError.typeMismatch, as Never is not possible to be created.
    public init(from decoder: Decoder) throws {
        throw DecodingError.typeMismatch(Never.self, DecodingError.Context(codingPath: decoder.codingPath,
                                                                           debugDescription: "Never can't be created"))
    }
    public func encode(to encoder: Encoder) throws { }
}
