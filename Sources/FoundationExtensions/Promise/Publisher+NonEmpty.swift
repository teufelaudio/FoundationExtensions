// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(Combine)
import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
    public func nonEmpty(fallback: @escaping () -> Result<Output, Failure>) -> NonEmptyPublisher<Self> {
        NonEmptyPublisher(upstream: self, onEmpty: fallback)
    }
}
#endif
