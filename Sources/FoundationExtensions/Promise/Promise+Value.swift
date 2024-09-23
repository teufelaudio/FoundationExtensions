// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.Promise where Output: Sendable {
    /// Convert a `Promise<Output, Error>` to `async throws -> Output`.
    ///
    /// Usage
    ///
    ///     Publishers.Promise<Int, Error>(value: 1).value()
    public func value() async throws -> Output {
        var iterator = self.values.makeAsyncIterator()
        guard let result = try await iterator.next() else {
            throw CancellationError()
        }
        return result
    }
}
