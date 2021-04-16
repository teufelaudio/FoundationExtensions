//
//  PromiseTests.swift
//  FoundationExtensionsTests
//
//  Created by Luiz Rodrigo Martins Barbosa on 19.03.21.
//  Copyright © 2021 Lautsprecher Teufel GmbH. All rights reserved.
//

#if !os(watchOS)
import Combine
import FoundationExtensions
import XCTest

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class PromiseTests: XCTestCase {
    func testInitWithUpstreamThatSendsOneValueAndCompletes() {
        let subject = PassthroughSubject<String, String>()
        let promise = Publishers.Promise({ subject })
        let waiter = assert(publisher: promise, eventuallyReceives: "!@$%@*#$", andCompletes: true, timeout: 0.00001)
        subject.send("!@$%@*#$")
        subject.send(completion: .finished)
        waiter()
    }

    func testInitWithUpstreamThatSendsOneValueAndNeverCompletes() {
        let subject = PassthroughSubject<String, String>()
        let promise = Publishers.Promise({ subject })
        let waiter = assert(publisher: promise, eventuallyReceives: "!@$%@*#$", andCompletes: true, timeout: 0.00001)
        subject.send("!@$%@*#$")
        waiter()
    }

    func testInitWithUpstreamThatSendsMultipleValuesAndNeverCompletes() {
        let subject = PassthroughSubject<String, String>()
        let promise = Publishers.Promise({ subject })
        let waiter = assert(publisher: promise, eventuallyReceives: "!@$%@*#$", andCompletes: true, timeout: 0.00001)
        subject.send("!@$%@*#$")
        subject.send("will")
        subject.send("never")
        subject.send("get")
        subject.send("this")
        waiter()
    }

    func testInitWithUpstreamThatCompletesWithoutValues() {
        let subject = PassthroughSubject<String, String>()
        let promise = Publishers.Promise({ subject })
        let waiter = assert(
            publisher: promise,
            completesWithoutValues: .failedWithError(.completedWithoutValue),
            timeout: 0.00001
        )
        subject.send(completion: .finished)
        waiter()
    }

    func testInitWithUpstreamThatCompletesWithErrorBeforeValues() {
        let subject = PassthroughSubject<String, String>()
        let promise = Publishers.Promise({ subject })
        let waiter = assert(
            publisher: promise,
            completesWithoutValues: .failedWithError(.receivedError("cataploft!")),
            timeout: 0.00001
        )
        subject.send(completion: .failure("cataploft!"))
        waiter()
    }

    func testInitWithUpstreamThatCompletesWithErrorAfterSendingValueSoPromiseIgnoresTheError() {
        let subject = PassthroughSubject<String, String>()
        let promise = Publishers.Promise({ subject })
        let waiter = assert(publisher: promise, eventuallyReceives: "!@$%@*#$", andCompletes: true, timeout: 0.00001)
        subject.send("!@$%@*#$")
        subject.send(completion: .failure("cataploft!"))
        waiter()
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension PromiseTests {
    func testInitWithClosureThatSendsOneValueAndCompletes() {
        let subject = PassthroughSubject<String, String>()
        let promise = Publishers.Promise<String, String> { completion in
            subject.sink(
                receiveCompletion: { result in
                    if case let .failure(error) = result {
                        completion(.failure(error))
                    }
                },
                receiveValue: { value in
                    completion(.success(value))
                }
            )
        }
        let waiter = assert(publisher: promise, eventuallyReceives: "!@$%@*#$", andCompletes: true, timeout: 0.00001)
        subject.send("!@$%@*#$")
        subject.send(completion: .finished)
        waiter()
    }

    func testInitWithClosureThatSendsOneValueAndNeverCompletes() {
        let subject = PassthroughSubject<String, String>()
        let promise = Publishers.Promise<String, String> { completion in
            subject.sink(
                receiveCompletion: { result in
                    if case let .failure(error) = result {
                        completion(.failure(error))
                    }
                },
                receiveValue: { value in
                    completion(.success(value))
                }
            )
        }
        let waiter = assert(publisher: promise, eventuallyReceives: "!@$%@*#$", andCompletes: true, timeout: 0.00001)
        subject.send("!@$%@*#$")
        waiter()
    }

    func testInitWithClosureThatSendsMultipleValuesAndNeverCompletes() {
        let subject = PassthroughSubject<String, String>()
        let promise = Publishers.Promise<String, String> { completion in
            subject.sink(
                receiveCompletion: { result in
                    if case let .failure(error) = result {
                        completion(.failure(error))
                    }
                },
                receiveValue: { value in
                    completion(.success(value))
                }
            )
        }
        let waiter = assert(publisher: promise, eventuallyReceives: "!@$%@*#$", andCompletes: true, timeout: 0.00001)
        subject.send("!@$%@*#$")
        subject.send("will")
        subject.send("never")
        subject.send("get")
        subject.send("this")
        waiter()
    }

    func testInitWithClosureThatCompletesWithErrorBeforeValues() {
        let subject = PassthroughSubject<String, String>()
        let promise = Publishers.Promise<String, String> { completion in
            subject.sink(
                receiveCompletion: { result in
                    if case let .failure(error) = result {
                        completion(.failure(error))
                    }
                },
                receiveValue: { value in
                    completion(.success(value))
                }
            )
        }
        let waiter = assert(
            publisher: promise,
            completesWithoutValues: .failedWithError(.receivedError("cataploft!")),
            timeout: 0.00001
        )
        subject.send(completion: .failure("cataploft!"))
        waiter()
    }

    func testInitWithClosureThatCompletesWithErrorAfterSendingValueSoPromiseIgnoresTheError() {
        let subject = PassthroughSubject<String, String>()
        let promise = Publishers.Promise<String, String> { completion in
            subject.sink(
                receiveCompletion: { result in
                    if case let .failure(error) = result {
                        completion(.failure(error))
                    }
                },
                receiveValue: { value in
                    completion(.success(value))
                }
            )
        }
        let waiter = assert(publisher: promise, eventuallyReceives: "!@$%@*#$", andCompletes: true, timeout: 0.00001)
        subject.send("!@$%@*#$")
        subject.send(completion: .failure("cataploft!"))
        waiter()
    }
}

extension XCTestCase {
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func assert<P: Publisher>(
        publisher: P,
        eventuallyReceives values: P.Output...,
        andCompletes: Bool = false,
        timeout: TimeInterval
    ) -> () -> Void where P.Output: Equatable {
        var collectedValues: [P.Output] = []
        let valuesExpectation = expectation(description: "Expected values")
        let completionExpectation = expectation(description: "Expected completion")
        valuesExpectation.expectedFulfillmentCount = values.count
        if !andCompletes { completionExpectation.fulfill() }
        let cancellable = publisher.sink(
            receiveCompletion: { result in
                switch result {
                case .finished:
                    if andCompletes { completionExpectation.fulfill() }
                case let .failure(error):
                    XCTFail("Received failure: \(error)")
                }
            },
            receiveValue: { value in
                collectedValues.append(value)
                valuesExpectation.fulfill()
            }
        )

        return { [weak self] in
            guard let self = self else {
                XCTFail("Test ended before waiting for expectations")
                return
            }
            self.wait(for: [valuesExpectation, completionExpectation], timeout: timeout)
            XCTAssertEqual(collectedValues, values, "Values don't match:\nreceived:\n\(collectedValues)\n\nexpected:\n\(values)")
            _ = cancellable
        }
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func assert<P: Publisher>(
        publisher: P,
        completesWithoutValues: ValidateCompletion<P.Failure>,
        timeout: TimeInterval
    ) -> () -> Void {
        let completionExpectation = expectation(description: "Expected completion")
        let cancellable = publisher.sink(
            receiveCompletion: { result in
                XCTAssertTrue(completesWithoutValues.isExpected(result), "Unexpected completion: \(result)")
                completionExpectation.fulfill()
            },
            receiveValue: { value in
                XCTFail("Unexpected value received: \(value)")
            }
        )

        return { [weak self] in
            guard let self = self else {
                XCTFail("Test ended before waiting for expectations")
                return
            }
            self.wait(for: [completionExpectation], timeout: timeout)
            _ = cancellable
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct ValidateCompletion<Failure: Error> {
    let isExpected: (Subscribers.Completion<Failure>) -> Bool
    public init(validate: @escaping (Subscribers.Completion<Failure>) -> Bool) {
        self.isExpected = validate
    }

    public static var isSuccess: ValidateCompletion {
        ValidateCompletion { result in
            guard case .finished = result else { return false }
            return true
        }
    }

    public static var isFailure: ValidateCompletion {
        ValidateCompletion { result in
            guard case .failure = result else { return false }
            return true
        }
    }

    public static func failedWithError(_ errorPredicate: @escaping (Failure) -> Bool) -> ValidateCompletion {
        ValidateCompletion { result in
            guard case let .failure(error) = result else { return false }
            return errorPredicate(error)
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension ValidateCompletion where Failure: Equatable {
    public static func failedWithError(_ expectedError: Failure) -> ValidateCompletion {
        ValidateCompletion { result in
            guard case let .failure(error) = result else { return false }
            return error == expectedError
        }
    }
}
#endif
