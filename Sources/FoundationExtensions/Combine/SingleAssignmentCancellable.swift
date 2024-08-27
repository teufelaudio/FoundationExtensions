import Combine
import Foundation

/// Credit by Krunoslav Zaher, RxSwift:
/// https://github.com/ReactiveX/RxSwift/blob/main/RxSwift/Disposables/SingleAssignmentDisposable.swift
public final class SingleAssignmentCancellable: Cancellable {
    private enum CancelState: Int32 {
        case cancelled = 1
        case cancellableSet = 2
    }

    // state
    private let state = AtomicInt(0)
    private var innerCancellable = nil as AnyCancellable?

    /// - returns: A value that indicates whether the object is disposed.
    public var isCancelled: Bool {
        isFlagSet(self.state, CancelState.cancelled.rawValue)
    }

    /// Initializes a new instance of the `SingleAssignmentCancellable`.
    public init() {
    }

    /// Gets or sets the underlying disposable. After disposal, the result of getting this property is undefined.
    ///
    /// **Throws exception if the `SingleAssignmentDisposable` has already been assigned to.**
    public func setCancellable(_ cancellable: Cancellable) {
        self.innerCancellable = AnyCancellable { cancellable.cancel() }

        let previousState = fetchOr(self.state, CancelState.cancellableSet.rawValue)

        if (previousState & CancelState.cancellableSet.rawValue) != 0 {
            fatalError("oldState.disposable != nil")
        }

        if (previousState & CancelState.cancelled.rawValue) != 0 {
            cancellable.cancel()
            self.innerCancellable = nil
        }
    }

    /// Disposes the underlying disposable.
    public func cancel() {
        let previousState = fetchOr(self.state, CancelState.cancelled.rawValue)

        if (previousState & CancelState.cancelled.rawValue) != 0 {
            return
        }

        if (previousState & CancelState.cancellableSet.rawValue) != 0 {
            guard let cancellable = self.innerCancellable else {
                fatalError("Disposable not set")
            }
            cancellable.cancel()
            self.innerCancellable = nil
        }
    }
}

final class AtomicInt: NSLock {
    fileprivate var value: Int32
    init(_ value: Int32 = 0) {
        self.value = value
    }
}

@discardableResult
@inline(__always)
func add(_ this: AtomicInt, _ value: Int32) -> Int32 {
    this.lock()
    let oldValue = this.value
    this.value += value
    this.unlock()
    return oldValue
}

@discardableResult
@inline(__always)
func sub(_ this: AtomicInt, _ value: Int32) -> Int32 {
    this.lock()
    let oldValue = this.value
    this.value -= value
    this.unlock()
    return oldValue
}

@discardableResult
@inline(__always)
func fetchOr(_ this: AtomicInt, _ mask: Int32) -> Int32 {
    this.lock()
    let oldValue = this.value
    this.value |= mask
    this.unlock()
    return oldValue
}

@inline(__always)
func load(_ this: AtomicInt) -> Int32 {
    this.lock()
    let oldValue = this.value
    this.unlock()
    return oldValue
}

@discardableResult
@inline(__always)
func increment(_ this: AtomicInt) -> Int32 {
    add(this, 1)
}

@discardableResult
@inline(__always)
func decrement(_ this: AtomicInt) -> Int32 {
    sub(this, 1)
}

@inline(__always)
func isFlagSet(_ this: AtomicInt, _ mask: Int32) -> Bool {
    (load(this) & mask) != 0
}
