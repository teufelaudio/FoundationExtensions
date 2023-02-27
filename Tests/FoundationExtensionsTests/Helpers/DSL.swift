// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

// MARK: - Iteration Handling
extension Int {
    /// Repeats the given function `self` times.
    /// - Parameter function: Function to repeat multiple times
    func times(_ function: () -> Void) {
        (0..<self).forEach { _ in function() }
    }
}
