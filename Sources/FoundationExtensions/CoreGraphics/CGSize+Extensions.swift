//
//  CGSize+Extensions.swift
//  FoundationExtensions
//
//  Created by Luis Reisewitz on 14.01.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

#if canImport(CoreGraphics)
import CoreGraphics

// MARK: - Helper for transforming to other types
extension CGSize {
    /// Transform the receiving CGSize to a CGPoint, using its `width` as the point's `x`,
    /// and the `height` as the point's `y`.
    public var asPoint: CGPoint {
        CGPoint(x: width, y: height)
    }
}

// MARK: - Handling Sizes
extension CGSize {
    public var longerSide: CGFloat {
        max(width, height)
    }
}

#endif
