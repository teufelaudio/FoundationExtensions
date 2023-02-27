// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

public protocol Emptyable {
    /// Should return an empty version of itself.
    /// - Warning: As it's used in e.g. `Presenter` and `PresenterWithInput`
    /// `memoizedHandleState`, it should never contain valid state. The only way that is okay is if
    /// the conforming type has no other possible states, meaning `empty` is also the only correct state.
    /// Compare e.g. `LaunchViewModel`.
    ///
    /// Otherwise, valid states might be discarded by the presenters as they compare equal to the
    /// `empty` implementation. This is not desired.
    static var empty: Self { get }
}
