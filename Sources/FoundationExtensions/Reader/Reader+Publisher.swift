//
//  Reader+Publisher.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 03.06.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

#if canImport(Combine)
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Reader where Value: Publisher {
    public func mapPublisher<NewOutput>(_ transform: @escaping (Value.Output) -> NewOutput)
    -> Reader<Environment, AnyPublisher<NewOutput, Value.Failure>> {
        mapValue { $0.map(transform).eraseToAnyPublisher() }
    }

    public func mapPublisherError<NewFailure>(_ transform: @escaping (Value.Failure) -> NewFailure)
    -> Reader<Environment, AnyPublisher<Value.Output, NewFailure>> {
        mapValue { $0.mapError(transform).eraseToAnyPublisher() }
    }

    public func bimapPublisher<NewOutput, NewFailure>(
        _ transform: @escaping (Value.Output) -> NewOutput,
        errorTransform: @escaping (Value.Failure) -> NewFailure
    ) -> Reader<Environment, AnyPublisher<NewOutput, NewFailure>> {
        mapValue { $0.map(transform).mapError(errorTransform).eraseToAnyPublisher() }
    }

    public func flatMapLatestPublisher<NewPublisher: Publisher>(
        _ transform: @escaping (Value.Output) -> NewPublisher
    ) -> Reader<Environment, AnyPublisher<NewPublisher.Output, Value.Failure>> where NewPublisher.Failure == Value.Failure {
        mapValue { $0.flatMapLatest { transform($0) }.eraseToAnyPublisher() }
    }

    public func flatMapLatestPublisher<NewPublisher: Publisher>(
        _ transform: @escaping (Value.Output) -> Reader<Environment, NewPublisher>
    ) -> Reader<Environment, AnyPublisher<NewPublisher.Output, NewPublisher.Failure>> where Value: Publisher, Value.Failure == NewPublisher.Failure {
        flatMap { publisher -> Reader<Environment, AnyPublisher<NewPublisher.Output, NewPublisher.Failure>> in
            Reader<Environment, AnyPublisher<NewPublisher.Output, NewPublisher.Failure>> { env in
                publisher.flatMapLatest { value -> AnyPublisher<NewPublisher.Output, NewPublisher.Failure> in
                    transform(value).inject(env).eraseToAnyPublisher()
                }.eraseToAnyPublisher()
            }
        }
    }

    public func flatMapPublisherError<NewPublisher: Publisher>(
        _ transform: @escaping (Value.Failure) -> NewPublisher
    ) -> Reader<Environment, AnyPublisher<Value.Output, NewPublisher.Failure>> where NewPublisher.Output == Value.Output {
        mapValue { $0.catch { transform($0) }.eraseToAnyPublisher() }
    }
}
#endif
