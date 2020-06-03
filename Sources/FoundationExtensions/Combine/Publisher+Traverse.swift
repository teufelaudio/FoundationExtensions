//
//  Publisher+Traverse.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 14.12.18.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

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
}
#endif
