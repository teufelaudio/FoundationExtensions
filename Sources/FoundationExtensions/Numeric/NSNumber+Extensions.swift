//
//  NSNumber+Extensions.swift
//  FoundationExtensions
//
//  Created by Oguz Yuksel on 01.11.22.
//  Copyright © 2022 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

extension NSNumber {
    public var signedDescription: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.positivePrefix = numberFormatter.plusSign
        numberFormatter.negativePrefix = numberFormatter.minusSign
        numberFormatter.zeroSymbol = "0"
        return numberFormatter.string(from: self)
    }
}
