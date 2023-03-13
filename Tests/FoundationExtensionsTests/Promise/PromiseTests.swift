// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if !os(watchOS)
import Combine
import FoundationExtensions
import XCTest

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class PromiseTests: XCTestCase {
    func testInitWithUpstreamThatSendsOneValueAndCompletes() {
        let subject = PassthroughSubject<String, String>()
        let promise = Publishers.Promise { subject.nonEmpty(fallback: { .failure("wrooong") }) }
        let waiter = assert(publisher: promise, eventuallyReceives: "!@$%@*#$", andCompletes: true, timeout: 0.00001)
        subject.send("!@$%@*#$")
        subject.send(completion: .finished)
        waiter()
    }

    func testInitWithUpstreamThatSendsOneValueAndNeverCompletes() {
        let subject = PassthroughSubject<String, String>()
        let promise = Publishers.Promise { subject.nonEmpty(fallback: { .failure("wrooong") }) }
        let waiter = assert(publisher: promise, eventuallyReceives: "!@$%@*#$", andCompletes: true, timeout: 0.00001)
        subject.send("!@$%@*#$")
        waiter()
    }

    func testInitWithUpstreamThatSendsMultipleValuesAndNeverCompletes() {
        let subject = PassthroughSubject<String, String>()
        let promise = Publishers.Promise { subject.nonEmpty(fallback: { .failure("wrooong") }) }
        let waiter = assert(publisher: promise, eventuallyReceives: "!@$%@*#$", andCompletes: true, timeout: 0.00001)
        subject.send("!@$%@*#$")
        subject.send("will")
        subject.send("never")
        subject.send("get")
        subject.send("this")
        waiter()
    }

    func testInitWithUpstreamThatCompletesWithErrorBeforeValues() {
        let subject = PassthroughSubject<String, String>()
        let promise = Publishers.Promise { subject.nonEmpty(fallback: { .success("wrooong") }) }
        let waiter = assert(
            publisher: promise,
            completesWithoutValues: .failedWithError("cataploft!"),
            timeout: 0.00001
        )
        subject.send(completion: .failure("cataploft!"))
        waiter()
    }

    func testInitWithUpstreamThatCompletesWithErrorAfterSendingValueSoPromiseIgnoresTheError() {
        let subject = PassthroughSubject<String, String>()
        let promise = Publishers.Promise { subject.nonEmpty(fallback: { .failure("cataploft!") }) }
        let waiter = assert(publisher: promise, eventuallyReceives: "!@$%@*#$", andCompletes: true, timeout: 0.00001)
        subject.send("!@$%@*#$")
        subject.send(completion: .failure("cataploft!"))
        waiter()
    }

    func testInitWithUpstreamThatCompletesWithoutValuesButFallsbackToSuccess() {
        let subject = PassthroughSubject<String, String>()
        let promise = Publishers.Promise { subject.nonEmpty(fallback: { .success("hey, nice fallback, dude") }) }
        let waiter = assert(
            publisher: promise,
            eventuallyReceives: "hey, nice fallback, dude",
            andCompletes: true,
            timeout: 0.00001
        )
        subject.send(completion: .finished)
        waiter()
    }

    func testInitWithUpstreamThatCompletesWithoutValuesButFallsbackToFailure() {
        let subject = PassthroughSubject<String, String>()
        let promise = Publishers.Promise { subject.nonEmpty(fallback: { .failure("failure fallback") }) }
        let waiter = assert(
            publisher: promise,
            completesWithoutValues: .failedWithError("failure fallback"),
            timeout: 0.00001
        )
        subject.send(completion: .finished)
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
            completesWithoutValues: .failedWithError("cataploft!"),
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

    func testPromiseZipManySuccess() {
        let subject1 = PassthroughSubject<String, String>()
        let subject2 = PassthroughSubject<String, String>()
        let subject3 = PassthroughSubject<String, String>()
        let subject4 = PassthroughSubject<String, String>()

        let promises: [Publishers.Promise<String, String>] = [subject1, subject2, subject3, subject4].map { subject in
            Publishers.Promise<String, String> { completion in
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
        }

        let zipped: Publishers.Promise<[String], String> = Publishers.Promise.zip(promises)

        let waiter = assert(
            publisher: zipped,
            eventuallyReceives: ["p1", "p2", "p3", "p4"],
            andCompletes: true,
            timeout: 0.00001
        )
        subject1.send("p1")
        subject4.send("p4")
        subject2.send("p2")
        subject3.send("p3")
        waiter()
    }

    func testValidStatusCodeWithIncorrectURLResponse() {
        let promise = Publishers.Promise<(data: Data, response: URLResponse), URLError>
            .init(value: (data: Data(), response: URLResponse()))
            .validStatusCode()

        let waiter = assert(publisher: promise, completesWithoutValues: .failedWithError { urlError in
            urlError.code == .badServerResponse
        }, timeout: 0.1)
        waiter()
    }

    func testValidStatusCodeWithStatus400() {
        let response = HTTPURLResponse(
            url: URL(string: "https://teufel.de")!,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil
        )!

        let promise = Publishers.Promise<(data: Data, response: URLResponse), URLError>
            .init(value: (data: Data(), response: response))
            .validStatusCode()

        let waiter = assert(publisher: promise, completesWithoutValues: .failedWithError { urlError in
            urlError.code == .badServerResponse
        }, timeout: 0.1)
        waiter()
    }

    func testValidStatusCodeWithStatus200() {
        let response = HTTPURLResponse(
            url: URL(string: "https://teufel.de")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        let promise = Publishers.Promise<(data: Data, response: URLResponse), URLError>
            .init(value: (data: Data(), response: response))
            .validStatusCode()

        let waiter = assert(publisher: promise, eventuallyReceives: [()], validatingOutput: { _, _ in true }, andCompletes: true, timeout: 0.1)
        waiter()
    }

    func testRetryForeverEventuallySucceeds() {
        var count = 0
        let promiseThatSucceedsAfter10Attempts = Publishers.Promise<String, AnyError>.init { completion in
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5)) {
                if count < 10 {
                    completion(.failure(AnyError()))
                    count += 1
                } else {
                    completion(.success("hello"))
                }
            }
            return AnyCancellable { }
        }.retry()

        let waiter = assert(publisher: promiseThatSucceedsAfter10Attempts,
                            eventuallyReceives: "hello",
                            andCompletes: true,
                            timeout: 0.1)
        waiter()
    }

    func testRetryForeverWithTimeout() {
        let promiseThatSucceedsAfter10Attempts = Publishers.Promise<String, AnyError> { completion in
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5)) {
                completion(.failure(AnyError()))
            }
            return AnyCancellable { }
        }
        .retry()
        .setFailureType(to: AnyError.self)
        .timeout(.milliseconds(50), scheduler: DispatchQueue.main, customError: { AnyError() })

        let waiter = assert(publisher: promiseThatSucceedsAfter10Attempts,
                            completesWithoutValues: .isFailure,
                            timeout: 0.1)
        waiter()
    }

    func test_PromiseValueComputedProperty_WhenPromisePublishesInt1After1SecondDelay_TryAwaitValueReturns1() async throws {
        // given
        let result = 1
        let sut = Publishers.Promise<Int, Error> { promise in
            Task {
                try await Task.sleep(nanoseconds: NSEC_PER_SEC)
                promise(.success(result))
            }
            return AnyCancellable {}
        }

        // when
        let promisedValue = try await sut.value

        // then
        XCTAssertEqual(promisedValue, result)
    }

    func test_PromiseValueComputedProperty_WhenPromisePublishesErrorAfter1SecondDelay_TryAwaitValueThrows() async throws {
        // given
        let result = TestFailure.foo
        let sut = Publishers.Promise<Int, Error> { promise in
            Task {
                try await Task.sleep(nanoseconds: NSEC_PER_SEC)
                promise(.failure(result))
            }
            return AnyCancellable {}
        }

        // when
        let error = await returnError { _ = try await sut.value } as? TestFailure

        XCTAssertEqual(error, result)
    }
}

// MARK: - Helpers
private enum TestFailure: Error {
    case foo
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private func returnError(_ context: @escaping () async throws -> Void) async -> Error? {
    do {
        try await context()
        return nil
    } catch {
        return error
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
        assert(
            publisher: publisher,
            eventuallyReceives: values,
            validatingOutput: ==,
            andCompletes: andCompletes,
            timeout: timeout
        )
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func assert<P: Publisher>(
        publisher: P,
        eventuallyReceives values: [P.Output],
        validatingOutput: @escaping (P.Output, P.Output) -> Bool,
        andCompletes: Bool = false,
        timeout: TimeInterval
    ) -> () -> Void {
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
            XCTAssertEqual(collectedValues.count, values.count, "Values don't match:\nreceived:\n\(collectedValues)\n\nexpected:\n\(values)")
            zip(collectedValues, values).forEach { collected, expected in
                XCTAssertTrue(validatingOutput(collected, expected), "Values don't match:\nreceived:\n\(collectedValues)\n\nexpected:\n\(values)")
            }
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
