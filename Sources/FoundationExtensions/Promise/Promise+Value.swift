// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Combine
import Foundation

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 8.0, *)
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
