// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

extension ResultType {
    /// Possible wrapped value, or default value provided as parameter.
    ///
    /// - Parameter alternative: a default value as a fallback for the possible value of the original container
    /// - Returns: Possible wrapped value, or default value provided as parameter
    public static func ?? (lhs: Self, rhs: @autoclosure () -> Success) -> Success {
        return lhs.value ?? rhs()
    }

    /// Possible wrapped value, or default value provided as parameter.
    ///
    /// - Parameter alternative: a default value as a fallback for the possible value of the original container. It can be
    ///             also an error.
    /// - Returns: Possible wrapped value, or default value provided as parameter. In case the parameter is also
    ///            an error, it will return the parameter error.
    public static func ?? (lhs: Self, rhs: @autoclosure () -> Self) -> Self {
        if lhs.isSuccess {
            return lhs
        }

        return rhs()
    }
}
