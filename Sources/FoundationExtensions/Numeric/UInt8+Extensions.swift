//
//  UInt8+Extensions.swift
//  FoundationExtensions
//
//  Created by Oguz Yuksel on 01.11.22.
//  Copyright © 2022 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

extension UInt8: SignedDescribable {
    public var signedDescription: String? { NSNumber(value: self).signedDescription }
}
