// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(Combine)
import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
    public func flatMapResult<T>(
        _ transform: @escaping (Self.Output) -> Result<T, Failure>
    ) -> Publishers.FlatMapLatest<Self, Result<T, Failure>.Publisher> {
        flatMapLatest { value in
            transform(value).publisher
        }
    }
}
#endif
