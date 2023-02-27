// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import CoreGraphics

extension CGFloat {
    private func transform(
        fromLowerBound: Self,
        fromUpperBound: Self,
        toLowerBound: Self,
        toUpperBound: Self) -> Self {
        let positionInRange = (self - fromLowerBound) / (fromUpperBound - fromLowerBound)
        return (positionInRange * (toUpperBound - toLowerBound)) + toLowerBound
    }

    public func trasformation(from: ClosedRange<Self>, to: ClosedRange<Self>) -> Self {
        transform(
            fromLowerBound: from.lowerBound,
            fromUpperBound: from.upperBound,
            toLowerBound: to.lowerBound,
            toUpperBound: to.upperBound)
    }
}
