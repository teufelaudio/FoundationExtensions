// Copyright © 2026 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(Combine)
import Foundation

/// Simple gate for Promise: allow only the first delivery; ignore late sends after cancellation.
final class PromiseGate: @unchecked Sendable {
    private let lock = NSLock()
    private var state: State = .pending

    /// Returns false if already cancelled or delivered.
    func beginDeliver() -> Bool {
        lock.lock()
        defer { lock.unlock() }
        guard state == .pending else { return false }
        state = .delivered
        return true
    }

    /// Marks cancel so late completions are ignored.
    func cancel() {
        lock.lock()
        if state == .pending {
            state = .cancelled
        }
        lock.unlock()
    }

    private enum State {
        case pending
        case cancelled
        case delivered
    }
}
#endif
