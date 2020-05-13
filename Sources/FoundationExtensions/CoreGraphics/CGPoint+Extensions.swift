//
//  CGPoint+Extensions.swift
//  FoundationExtensions
//
//  Created by Luis Reisewitz on 14.01.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

import CoreGraphics

// MARK: - AdditiveArithmetic Conformance
extension CGPoint: AdditiveArithmetic {
    public static func -= (lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }

    public static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    public static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }

    public static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

// MARK: - Helper for constraining values
extension CGPoint {
    public var noX: CGPoint {
        CGPoint(x: 0, y: y)
    }

    public var onlyPositive: CGPoint {
        CGPoint(x: x.clamped(to: 0...CGFloat.greatestFiniteMagnitude),
                y: y.clamped(to: 0...CGFloat.greatestFiniteMagnitude))
    }
}
