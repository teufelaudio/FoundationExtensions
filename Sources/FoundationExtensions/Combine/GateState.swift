// Copyright © 2026 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(Combine)
import Foundation

final class GateState: @unchecked Sendable {
    private let semaphore: DispatchSemaphore?
    private let lock = NSLock()
    private var state: State = .waiting
    private var signaled = false

    init(semaphore: DispatchSemaphore? = nil) {
        self.semaphore = semaphore
    }

    func markEmitted() -> Bool {
        lock.lock()
        defer { lock.unlock() }
        guard state == .waiting else { return false }
        state = .emitted
        return true
    }

    func wait() {
        semaphore?.wait()
    }

    func cancel() {
        lock.lock()
        if state == .waiting {
            state = .cancelled
        }
        lock.unlock()
        signalOnce()
    }

    func signalOnce() {
        guard let semaphore else { return }
        lock.lock()
        let shouldSignal = !signaled
        if shouldSignal {
            signaled = true
        }
        lock.unlock()
        if shouldSignal {
            semaphore.signal()
        }
    }

    func signalIfEmitted() {
        guard let semaphore else { return }
        lock.lock()
        let shouldSignal = (state == .emitted) && !signaled
        if shouldSignal {
            signaled = true
        }
        lock.unlock()
        if shouldSignal {
            semaphore.signal()
        }
    }

    private enum State {
        case waiting
        case cancelled
        case emitted
    }
}
#endif
