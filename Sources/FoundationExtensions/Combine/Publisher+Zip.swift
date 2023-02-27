// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(Combine)
import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
    public static func zip<P: Publisher>(_ publishers: [P]) -> AnyPublisher<[P.Output], P.Failure> where P.Output == Output, P.Failure == Failure {
        switch publishers.count {
        case ...0:
            return Empty().eraseToAnyPublisher()
        case 1:
            return publishers[0].map { [$0] }.eraseToAnyPublisher()
        default:
            let result = publishers[0].map { [$0] }.eraseToAnyPublisher()

            return publishers.dropFirst().reduce(result) { partial, current in
                partial
                    .zip(current)
                    .map { accumulation, next in accumulation + [next] }
                    .eraseToAnyPublisher()
            }
        }
    }
}
#endif
