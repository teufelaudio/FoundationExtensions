// Copyright © 2025 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(Combine)
import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
    @inlinable
    public func eraseToPromise(
        onEmpty fallback: @Sendable @escaping () -> Result<Output, Failure>? = { nil }
    ) -> Publishers.Promise<Output, Failure> {
        Publishers.Promise(self, onEmpty: fallback)
    }

    @inlinable
    public func eraseToPromise(
        onEmpty fallback: @Sendable @autoclosure @escaping () -> Result<Output, Failure>? = nil
    ) -> Publishers.Promise<Output, Failure> {
        eraseToPromise(onEmpty: fallback)
    }

    @inline(never)
    public func assertPromise(_ prefix: String = "", file: StaticString = #file, line: UInt = #line) -> Publishers.Promise<Output, Failure> {
        Publishers.Promise.unsafe(self, prefix: prefix, file: file, line: line)
    }

    @inline(never)
    public func assertPromise(_ prefix: String = "", file: StaticString = #file, line: UInt = #line) -> Publishers.Promise<Output, Never> where Failure == Never {
        Publishers.Promise.unsafe(self, prefix: prefix, file: file, line: line)
    }
}
#endif
