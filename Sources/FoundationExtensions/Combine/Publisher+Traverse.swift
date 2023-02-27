// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(Combine)
import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
    // Traverse Publisher, Publisher
    public func traverse<NewOutput, NewFailure: Error>(_ transform: @escaping (Output) -> AnyPublisher<NewOutput, NewFailure>)
    -> AnyPublisher<AnyPublisher<NewOutput, NewFailure>, Failure> {
        map { transform($0) }.eraseToAnyPublisher()
    }

    public func traverse<Environment, A>(_ transform: @escaping (Output) -> Reader<Environment, A>) -> Reader<Environment, AnyPublisher<A, Failure>> {
        Reader { env in
            self.map { value in
                transform(value).inject(env)
            }.eraseToAnyPublisher()
        }
    }
}
#endif
