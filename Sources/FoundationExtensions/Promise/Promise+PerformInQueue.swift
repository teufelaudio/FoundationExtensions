//
//  Promise+PerformInQueue.swift
//  FoundationExtensions
//
//  Created by Luiz Rodrigo Martins Barbosa on 17.04.21.
//  Copyright © 2021 Lautsprecher Teufel GmbH. All rights reserved.
//

#if canImport(Combine)
import Combine
import Dispatch
import Foundation

extension DispatchWorkItem: Cancellable { }

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.Promise {
    public static func perform(in queue: DispatchQueue, operation: @escaping () throws -> Output) -> Self where Failure == Error {
        .init { completion in
            let workItem = DispatchWorkItem {
                do {
                    let value = try operation()
                    completion(.success(value))
                } catch {
                    completion(.failure(error))
                }
            }

            queue.async(execute: workItem)
            return workItem
        }
    }

    public static func perform(in queue: DispatchQueue, operation: @escaping () -> Output) -> Self where Failure == Never {
        .init { completion in
            let workItem = DispatchWorkItem {
                let value = operation()
                completion(.success(value))
            }

            queue.async(execute: workItem)
            return workItem
        }
    }
}
#endif
