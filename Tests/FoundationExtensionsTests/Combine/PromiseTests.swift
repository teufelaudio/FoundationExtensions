// Copyright © 2025 Lautsprecher Teufel GmbH. All rights reserved.

import XCTest
@preconcurrency import Combine
@testable @preconcurrency import FoundationExtensions

final class PromiseTests: XCTestCase {
    func testPromise_OperationClosure() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 success")
        let expectationPromise1Operation = XCTestExpectation(description: "promise1 operation executed")

        let promise1 = Publishers.Promise<Int, MockError> { promise in
            expectationPromise1Operation.fulfill()
            promise(.success(42))
            return AnyCancellable { }
        }

        var value1: Int?
        let cancellable1 = promise1.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
            receiveValue: { value1 = $0 }
        )

        let resultExpectations1 = XCTWaiter.wait(for: [
            expectationPromise1ReceiveCompletion,
            expectationPromise1Operation
        ], timeout: 0.1)
        XCTAssertEqual(resultExpectations1, .completed)
        XCTAssertEqual(value1, 42)

        // Test error case
        let expectationPromise2ReceiveCompletion = XCTestExpectation(description: "promise2 failure")
        let expectationPromise2Operation = XCTestExpectation(description: "promise2 operation executed")
        let expectationPromise2ReceiveValue = XCTestExpectation(description: "promise2 does not receive value")

        let promise2 = Publishers.Promise<Int, MockError> { promise in
            expectationPromise2Operation.fulfill()
            promise(.failure(.foo))
            return AnyCancellable { }
        }

        let cancellable2 = promise2.sink(
            receiveCompletion: { if case .failure(MockError.foo) = $0 { expectationPromise2ReceiveCompletion.fulfill() } },
            receiveValue: { _ in expectationPromise2ReceiveValue.fulfill() }
        )

        let resultExpectations2 = XCTWaiter.wait(for: [
            expectationPromise2ReceiveCompletion,
            expectationPromise2Operation
        ], timeout: 0.1)
        let resultExpectationPromise2ReceiveValue = XCTWaiter.wait(for: [expectationPromise2ReceiveValue], timeout: 0.3)
        XCTAssertEqual(resultExpectations2, .completed)
        XCTAssertEqual(resultExpectationPromise2ReceiveValue, .timedOut, "Expectation was unexpectedly fulfilled")

        // Test cancellation
        let expectationPromise3Operation = XCTestExpectation(description: "promise3 operation executed")
        let expectationPromise3Cancellation = XCTestExpectation(description: "promise3 cancelled")

        let promise3 = Publishers.Promise<Int, MockError> { _ in
            expectationPromise3Operation.fulfill()
            return AnyCancellable {
                expectationPromise3Cancellation.fulfill()
            }
        }

        let cancellable3 = promise3.sink(
            receiveCompletion: { _ in },
            receiveValue: { _ in }
        )

        cancellable3.cancel()

        let resultExpectations3 = XCTWaiter.wait(for: [
            expectationPromise3Operation,
            expectationPromise3Cancellation
        ], timeout: 0.1)
        XCTAssertEqual(resultExpectations3, .completed)

        _ = cancellable1
        _ = cancellable2
    }

    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func testPromise_asyncInit() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 success")

        let promise1 = Publishers.Promise<Int, Error> {
            try await Task.sleep(nanoseconds: 1)
            return 42
        }

        var value1: Int?
        let cancellable1 = promise1.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
            receiveValue: { value1 = $0 }
        )

        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 1.0)
        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .completed)
        XCTAssertEqual(value1, 42)

        // Error case
        let expectationPromise2ReceiveCompletion = XCTestExpectation(description: "promise2 failure")
        let expectationPromise2ReceiveValue = XCTestExpectation(description: "promise2 does not receive value")

        let promise2 = Publishers.Promise<Int, Error> {
            try await Task.sleep(nanoseconds: 1)
            throw MockError.foo
        }

        let cancellable2 = promise2.sink(
            receiveCompletion: { if case .failure = $0 { expectationPromise2ReceiveCompletion.fulfill() } },
            receiveValue: { _ in expectationPromise2ReceiveValue.fulfill() }
        )

        let resultExpectationPromise2ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise2ReceiveCompletion], timeout: 1.0)
        let resultExpectationPromise2ReceiveValue = XCTWaiter.wait(for: [expectationPromise2ReceiveValue], timeout: 0.3)
        XCTAssertEqual(resultExpectationPromise2ReceiveCompletion, .completed)
        XCTAssertEqual(resultExpectationPromise2ReceiveValue, .timedOut, "Expectation was unexpectedly fulfilled")

        _ = cancellable1
        _ = cancellable2
    }

    func testPromise_Value() {
        let expectation = XCTestExpectation(description: "value")
        let promise = Publishers.Promise(value: 1)
        var value: Int?
        let cancellable = promise
            .sink(
                receiveCompletion: { if case .finished = $0 { expectation.fulfill() } },
                receiveValue: { value = $0 }
            )


        let result = XCTWaiter.wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(result, .completed)
        XCTAssertEqual(value, 1)
        _ = cancellable
    }

    func testPromise_Error() {
        let expectation = XCTestExpectation(description: "failure")
        let promise = Publishers.Promise(outputType: Void.self, error: MockError.foo)

        let cancellable = promise
            .sink(
                receiveCompletion: { if case .failure(.foo) = $0 { expectation.fulfill() } },
                receiveValue: { }
            )

        let result = XCTWaiter.wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(result, .completed)
        _ = cancellable
    }

    func testPromise_Result() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 fails")
        let expectationPromise1ReceiveValue = XCTestExpectation(description: "promise1 does not receive value")
        let promise1 = Publishers.Promise<Void, MockError>(.failure(.foo))

        let cancellable1 = promise1
            .sink(
                receiveCompletion: { if case .failure(.foo) = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
                receiveValue: { expectationPromise1ReceiveValue.fulfill() }
            )

        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 0.1)
        let resultExpectationPromise1ReceiveValue = XCTWaiter.wait(for: [expectationPromise1ReceiveValue], timeout: 0.3)

        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .completed)
        XCTAssertEqual(resultExpectationPromise1ReceiveValue, .timedOut, "Expectation was unexpectedly fulfilled")

        let expectationPromise2ReceiveCompletion = XCTestExpectation(description: "promise2 finished")
        let promise2 = Publishers.Promise<Int, MockError>(.success(1))
        var value2: Int?

        let cancellable2 = promise2
            .sink(
                receiveCompletion: { if case .finished = $0 { expectationPromise2ReceiveCompletion.fulfill() } },
                receiveValue: { value2 = $0 }
            )

        let resultExpectationPromise2ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise2ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise2ReceiveCompletion, .completed)
        XCTAssertEqual(value2, 1)

        _ = cancellable1
        _ = cancellable2
    }

    func testPromise_Empty() {
        let expectation = XCTestExpectation(description: "hangs")
        let promise = Publishers.Promise(outputType: Void.self, failureType: MockError.self)

        let cancellable = promise
            .sink(
                receiveCompletion: { _ in expectation.fulfill() },
                receiveValue: { expectation.fulfill() }
            )

        let result = XCTWaiter.wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(result, .timedOut, "Expectation was unexpectedly fulfilled")
        _ = cancellable
    }

    func testPromise_map() {
        let expectationPromiseReceiveCompletion = XCTestExpectation(description: "promise is finished")

        let subject = PassthroughSubject<Int, Never>()
        let promise = subject
            .assertPromise("testPromise_map: ")
            .map(String.init)

        var value: String?

        let cancellable = promise
            .sink(
                receiveCompletion: { if case .finished = $0 { expectationPromiseReceiveCompletion.fulfill() } },
                receiveValue: { value = $0 }
            )

        subject.send(1)
        subject.send(2)

        let resultExpectationPromiseReceiveCompletion = XCTWaiter.wait(for: [expectationPromiseReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromiseReceiveCompletion, .completed)
        XCTAssertEqual(value, "1")

        _ = cancellable

        let expectationPromise2ReceiveCompletion = XCTestExpectation(description: "promise2 success")
        
        struct TestModel {
            let value: Int
            var stringValue: String { String(value) }
        }
        
        let subject2 = PassthroughSubject<TestModel, Never>()
        let promise2 = subject2
            .assertPromise("testPromise_map_keyPath: ")
            .map(\.value)
        
        var value2: Int?
        let cancellable2 = promise2.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise2ReceiveCompletion.fulfill() } },
            receiveValue: { value2 = $0 }
        )
        
        subject2.send(TestModel(value: 42))
        subject2.send(completion: .finished)
        
        let resultExpectationPromise2ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise2ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise2ReceiveCompletion, .completed)
        XCTAssertEqual(value2, 42)

        let expectationPromise3ReceiveCompletion = XCTestExpectation(description: "promise3 success")
        
        let subject3 = PassthroughSubject<TestModel, Never>()
        let promise3 = subject3
            .assertPromise("testPromise_map_keyPath: ")
            .map(\.stringValue, \.value)

        var value3: (String, Int)?
        let cancellable3 = promise3.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise3ReceiveCompletion.fulfill() } },
            receiveValue: { value3 = $0 }
        )
        
        subject3.send(TestModel(value: 42))
        subject3.send(completion: .finished)
        
        let resultExpectationPromise3ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise3ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise3ReceiveCompletion, .completed)
        XCTAssertEqual(value3?.0, "42")
        XCTAssertEqual(value3?.1, 42)

        _ = cancellable2
        _ = cancellable3
    }

    func testPromise_tryMap() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 is finished")

        let subject1 = PassthroughSubject<String, MockError>()
        let promise1 = subject1
            .assertPromise("testPromise_tryMap: ")
            .tryMap {
                guard let str = Int($0)
                else { throw MockError.foo }
                return str
            }

        var value1: Int?

        let cancellable1 = promise1
            .sink(
                receiveCompletion: { if case .finished = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
                receiveValue: { value1 = $0 }
            )

        subject1.send("1")
        subject1.send("a")

        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .completed)
        XCTAssertEqual(value1, 1)

        let expectationPromise2ReceiveCompletion = XCTestExpectation(description: "promise2 is failed")
        let expectationPromise2ReceiveValue = XCTestExpectation(description: "promise2 does not receive value")

        let subject2 = PassthroughSubject<String, MockError>()
        let promise2 = subject2
            .assertPromise("testPromise_tryMap: ")
            .tryMap {
                guard let str = Int($0)
                else { throw MockError.foo }
                return str
            }

        let cancellable2 = promise2
            .sink(
                receiveCompletion: { if case .failure(MockError.foo) = $0 { expectationPromise2ReceiveCompletion.fulfill() } },
                receiveValue: { _ in expectationPromise2ReceiveValue.fulfill() }
            )


        subject2.send("a")
        subject2.send("1")

        let resultExpectationPromise2ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise2ReceiveCompletion], timeout: 0.1)
        let resultExpectationPromise2ReceiveValue = XCTWaiter.wait(for: [expectationPromise2ReceiveValue], timeout: 0.3)
        XCTAssertEqual(resultExpectationPromise2ReceiveCompletion, .completed)
        XCTAssertEqual(resultExpectationPromise2ReceiveValue, .timedOut, "Expectation was unexpectedly fulfilled")

        _ = cancellable1
        _ = cancellable2
    }

    func testPromise_mapError() {
        let expectationPromiseReceiveCompletion = XCTestExpectation(description: "promise is failed")
        let expectationPromiseReceiveValue = XCTestExpectation(description: "promise does not receive value")

        let subject = PassthroughSubject<Void, URLError>()
        let promise = subject
            .assertPromise("testPromise_mapError: ")
            .mapError { _ in MockError.foo }

        let cancellable = promise
            .sink(
                receiveCompletion: { if case .failure(.foo) = $0 { expectationPromiseReceiveCompletion.fulfill() } },
                receiveValue: { _ in expectationPromiseReceiveValue.fulfill() }
            )

        subject.send(completion: .failure(.init(.badURL)))
        subject.send(())

        let resultExpectationPromiseReceiveCompletion = XCTWaiter.wait(for: [expectationPromiseReceiveCompletion], timeout: 0.1)
        let resultExpectationPromiseReceiveValue = XCTWaiter.wait(for: [expectationPromiseReceiveValue], timeout: 0.3)
        XCTAssertEqual(resultExpectationPromiseReceiveCompletion, .completed)
        XCTAssertEqual(resultExpectationPromiseReceiveValue, .timedOut, "Expectation was unexpectedly fulfilled")

        _ = cancellable
    }

    func testPromise_zip() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 is finished")

        let subject1 = PassthroughSubject<Int, MockError>()
        let subject2 = PassthroughSubject<String, MockError>()
        let promise1 = Publishers.Promise.zip(
            subject1.assertPromise("testPromise_zip: "),
            subject2.assertPromise("testPromise_zip: ")
        )
        var value1: Int? = nil
        var value2: String? = nil
        let cancellable1 = promise1
            .sink(
                receiveCompletion: { if case .finished = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
                receiveValue: { value1 = $0; value2 = $1 }
            )

        subject1.send(1)
        subject2.send("1")
        subject1.send(2)
        subject2.send("2")

        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .completed)
        XCTAssertEqual(value1, 1)
        XCTAssertEqual(value2, "1")

        let expectationPromise2ReceiveCompletion = XCTestExpectation(description: "promise2 is failed")
        let expectationPromise2ReceiveValue = XCTestExpectation(description: "promise2 does not receive value")

        let subject3 = PassthroughSubject<Int, MockError>()
        let subject4 = PassthroughSubject<String, MockError>()
        let promise2 = Publishers.Promise.zip(
            subject3.assertPromise("testPromise_zip: "),
            subject4.assertPromise("testPromise_zip: ")
        )

        let cancellable2 = promise2
            .sink(
                receiveCompletion: { if case .failure(.foo) = $0 { expectationPromise2ReceiveCompletion.fulfill() } },
                receiveValue: { _ in expectationPromise2ReceiveValue.fulfill() }
            )

        subject3.send(completion: .failure(.foo))

        let resultExpectationPromise2ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise2ReceiveCompletion], timeout: 0.1)
        let resultExpectationPromise2ReceiveValue = XCTWaiter.wait(for: [expectationPromise2ReceiveValue], timeout: 0.3)
        XCTAssertEqual(resultExpectationPromise2ReceiveCompletion, .completed)
        XCTAssertEqual(resultExpectationPromise2ReceiveValue, .timedOut, "Expectation was unexpectedly fulfilled")

        let expectationPromise3ReceiveCompletion = XCTestExpectation(description: "promise3 is failed")
        let expectationPromise3ReceiveValue = XCTestExpectation(description: "promise3 does not receive value")

        let subject5 = PassthroughSubject<Int, MockError>()
        let subject6 = PassthroughSubject<String, MockError>()
        let promise3 = Publishers.Promise.zip(
            subject5.assertPromise("testPromise_zip: "),
            subject6.assertPromise("testPromise_zip: ")
        )

        let cancellable3 = promise3
            .sink(
                receiveCompletion: { if case .failure(.foo) = $0 { expectationPromise3ReceiveCompletion.fulfill() } },
                receiveValue: { _ in expectationPromise3ReceiveValue.fulfill() }
            )

        subject5.send(1)
        subject6.send(completion: .failure(.foo))

        let resultExpectationPromise3ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise3ReceiveCompletion], timeout: 0.1)
        let resultExpectationPromise3ReceiveValue = XCTWaiter.wait(for: [expectationPromise3ReceiveValue], timeout: 0.3)
        XCTAssertEqual(resultExpectationPromise3ReceiveCompletion, .completed)
        XCTAssertEqual(resultExpectationPromise3ReceiveValue, .timedOut, "Expectation was unexpectedly fulfilled")

        _ = cancellable1
        _ = cancellable2
        _ = cancellable3
    }

    func testPromise_assertNoFailure() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 success")

        let subject1 = PassthroughSubject<Int, Never>()
        let promise1 = subject1
            .assertPromise("testPromise_assertNoFailure: ")
            .assertNoFailure()

        var value1: Int?
        let cancellable1 = promise1.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
            receiveValue: { value1 = $0 }
        )

        subject1.send(42)
        subject1.send(completion: .finished)

        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .completed)
        XCTAssertEqual(value1, 42)

        _ = cancellable1
    }

    @available(iOS 14.0, *)
    func testPromise_catch() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 is finished")

        let subject1 = PassthroughSubject<Int, any Error>()
        let promise1 = subject1
            .assertPromise("testPromise_catch: ")
            .catch { _ in .init(error: MockError.foo) }

        var value1: Int?

        let cancellable1 = promise1
            .sink(
                receiveCompletion: { if case .finished = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
                receiveValue: { value1 = $0 }
            )

        subject1.send(1)
        subject1.send(completion: .failure(URLError(.badURL)))

        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 0.1)

        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .completed)
        XCTAssertEqual(value1, 1)

        let expectationPromise2ReceiveCompletion = XCTestExpectation(description: "promise2 is failed")
        let expectationPromise2ReceiveValue = XCTestExpectation(description: "promise2 does not receive value")

        let subject2 = PassthroughSubject<Void, any Error>()
        let promise2 = subject2
            .assertPromise("testPromise_catch: ")
            .catch { _ in .init(error: MockError.foo) }

        let cancellable2 = promise2
            .sink(
                receiveCompletion: { if case .failure(.foo) = $0 { expectationPromise2ReceiveCompletion.fulfill() } },
                receiveValue: { expectationPromise2ReceiveValue.fulfill() }
            )

        subject2.send(completion: .failure(URLError(.badURL)))
        subject2.send(())

        let resultExpectationPromise2ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise2ReceiveCompletion], timeout: 0.1)
        let resultExpectationPromise2ReceiveValue = XCTWaiter.wait(for: [expectationPromise2ReceiveValue], timeout: 0.3)
        XCTAssertEqual(resultExpectationPromise2ReceiveCompletion, .completed)
        XCTAssertEqual(resultExpectationPromise2ReceiveValue, .timedOut, "Expectation was unexpectedly fulfilled")

        _ = cancellable1
        _ = cancellable2
    }

    func testPromise_tryCatch() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 success")

        let subject1 = PassthroughSubject<Int, MockError>()
        let promise1 = subject1
            .assertPromise("testPromise_tryCatch: ")
            .tryCatch { error -> Publishers.Promise<Int, MockError> in
                XCTAssertEqual(error, .foo)
                return .init(value: 42)
            }

        var value1: Int?
        let cancellable1 = promise1.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
            receiveValue: { value1 = $0 }
        )

        subject1.send(completion: .failure(.foo))

        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .completed)
        XCTAssertEqual(value1, 42)

        let expectationPromise2ReceiveCompletion = XCTestExpectation(description: "promise2 failure")
        let expectationPromise2ReceiveValue = XCTestExpectation(description: "promise2 does not receive value")

        let subject2 = PassthroughSubject<Int, MockError>()
        let promise2 = subject2
            .assertPromise("testPromise_tryCatch: ")
            .tryCatch { error -> Publishers.Promise<Int, MockError> in
                throw error
            }

        let cancellable2 = promise2.sink(
            receiveCompletion: { if case .failure(MockError.foo) = $0 { expectationPromise2ReceiveCompletion.fulfill() } },
            receiveValue: { _ in expectationPromise2ReceiveValue.fulfill() }
        )

        subject2.send(completion: .failure(.foo))

        let resultExpectationPromise2ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise2ReceiveCompletion], timeout: 0.1)
        let resultExpectationPromise2ReceiveValue = XCTWaiter.wait(for: [expectationPromise2ReceiveValue], timeout: 0.3)
        XCTAssertEqual(resultExpectationPromise2ReceiveCompletion, .completed)
        XCTAssertEqual(resultExpectationPromise2ReceiveValue, .timedOut, "Expectation was unexpectedly fulfilled")

        _ = cancellable1
        _ = cancellable2
    }

    func testPromise_retry() {
        let expectationFiniteSuccess = XCTestExpectation(description: "Finite retry: success after 2 failures")
        let attemptCounterFiniteSuccess = Atomic(0)
        let maxRetriesFiniteSuccess = 2

        let promiseFiniteSuccess = Publishers.Promise<Int, MockError> { resolver in
            let attempt = attemptCounterFiniteSuccess.withLock { $0 += 1; return $0 }
            if attempt <= maxRetriesFiniteSuccess {
                resolver(.failure(.foo))
            } else {
                resolver(.success(42))
                expectationFiniteSuccess.fulfill()
            }
            return AnyCancellable { }
        }
        .retry(maxRetriesFiniteSuccess)

        var valueFiniteSuccess: Int?
        let cancellableFiniteSuccess = promiseFiniteSuccess.sink(
            receiveCompletion: { _ in },
            receiveValue: { valueFiniteSuccess = $0 }
        )

        wait(for: [expectationFiniteSuccess], timeout: 1.0)
        XCTAssertEqual(attemptCounterFiniteSuccess.value, maxRetriesFiniteSuccess + 1)
        XCTAssertEqual(valueFiniteSuccess, 42)
        _ = cancellableFiniteSuccess

        let expectationFiniteExhaust = XCTestExpectation(description: "Finite retry: exhaust attempts")
        let attemptCounterFiniteExhaust = Atomic(0)
        let maxRetriesFiniteExhaust = 3

        let promiseFiniteExhaust = Publishers.Promise<Int, MockError> { resolver in
            let attempt = attemptCounterFiniteExhaust.withLock { $0 += 1; return $0 }
            resolver(.failure(.foo))
            if attempt == maxRetriesFiniteExhaust + 1 {
                expectationFiniteExhaust.fulfill()
            }
            return AnyCancellable { }
        }
        .retry(maxRetriesFiniteExhaust)

        var errorFiniteExhaust: MockError?
        let cancellableFiniteExhaust = promiseFiniteExhaust.sink(
            receiveCompletion: {
                if case .failure(let error) = $0 { errorFiniteExhaust = error }
            },
            receiveValue: { _ in }
        )

        wait(for: [expectationFiniteExhaust], timeout: 1.0)
        XCTAssertEqual(attemptCounterFiniteExhaust.value, maxRetriesFiniteExhaust + 1)
        XCTAssertEqual(errorFiniteExhaust, .foo)
        _ = cancellableFiniteExhaust

        let expectationImmediateSuccess = XCTestExpectation(description: "Immediate success")
        let attemptCounterImmediateSuccess = Atomic(0)

        let promiseImmediateSuccess = Publishers.Promise<Int, MockError> { resolver in
            attemptCounterImmediateSuccess.withLock { $0 += 1 }
            resolver(.success(42))
            expectationImmediateSuccess.fulfill()
            return AnyCancellable { }
        }
        .retry(3)

        var valueImmediateSuccess: Int?
        let cancellableImmediateSuccess = promiseImmediateSuccess.sink(
            receiveCompletion: { _ in },
            receiveValue: { valueImmediateSuccess = $0 }
        )

        wait(for: [expectationImmediateSuccess], timeout: 1.0)
        XCTAssertEqual(attemptCounterImmediateSuccess.value, 1)
        XCTAssertEqual(valueImmediateSuccess, 42)
        _ = cancellableImmediateSuccess
    }

    func testPromise_share() {
        // Success case with multiple subscribers
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 success")
        let expectationPromise2ReceiveCompletion = XCTestExpectation(description: "promise2 success")
        let expectationUpstream1 = XCTestExpectation(description: "Upstream1 executes once")
        let sideEffectCounter1 = Atomic(0)

        let promise1 = Publishers.Promise<Int, Never> { resolver in
            sideEffectCounter1.withLock { $0 += 1 }
            expectationUpstream1.fulfill()
            resolver(.success(42))
            return AnyCancellable { }
        }
        .share()

        var value1: Int?
        let cancellable1 = promise1.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
            receiveValue: { value1 = $0 }
        )

        var value2: Int?
        let cancellable2 = promise1.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise2ReceiveCompletion.fulfill() } },
            receiveValue: { value2 = $0 }
        )

        let resultExpectations1 = XCTWaiter.wait(for: [
            expectationPromise1ReceiveCompletion,
            expectationPromise2ReceiveCompletion,
            expectationUpstream1
        ], timeout: 0.1)
        XCTAssertEqual(resultExpectations1, .completed)
        XCTAssertEqual(sideEffectCounter1.value, 1, "Upstream must execute exactly once")
        XCTAssertEqual(value1, 42)
        XCTAssertEqual(value2, 42)

        // Late subscriber after completion
        var value3: Int?
        let cancellable3 = promise1.sink(
            receiveCompletion: { _ in },
            receiveValue: { value3 = $0 }
        )
        XCTAssertEqual(value3, 42, "Late subscriber should receive cached value")

        // Error case with multiple subscribers
        let expectationPromise4ReceiveCompletion = XCTestExpectation(description: "promise4 failure")
        let expectationPromise5ReceiveCompletion = XCTestExpectation(description: "promise5 failure")
        let expectationUpstream2 = XCTestExpectation(description: "Upstream2 executes once")
        let sideEffectCounter2 = Atomic(0)

        let promise2 = Publishers.Promise<Int, MockError> { resolver in
            sideEffectCounter2.withLock { $0 += 1 }
            expectationUpstream2.fulfill()
            resolver(.failure(.foo))
            return AnyCancellable { }
        }
        .share()

        var error1: MockError?
        let cancellable4 = promise2.sink(
            receiveCompletion: { if case .failure(let error) = $0 {
                error1 = error
                expectationPromise4ReceiveCompletion.fulfill()
            }},
            receiveValue: { _ in }
        )

        var error2: MockError?
        let cancellable5 = promise2.sink(
            receiveCompletion: { if case .failure(let error) = $0 {
                error2 = error
                expectationPromise5ReceiveCompletion.fulfill()
            }},
            receiveValue: { _ in }
        )

        let resultExpectations2 = XCTWaiter.wait(for: [
            expectationPromise4ReceiveCompletion,
            expectationPromise5ReceiveCompletion,
            expectationUpstream2
        ], timeout: 0.1)
        XCTAssertEqual(resultExpectations2, .completed)
        XCTAssertEqual(sideEffectCounter2.value, 1, "Upstream must execute exactly once")
        XCTAssertEqual(error1, .foo)
        XCTAssertEqual(error2, .foo)

        // Late subscriber after completion
        var error3: MockError?
        let cancellable6 = promise2.sink(
            receiveCompletion: { if case .failure(let error) = $0 { error3 = error }},
            receiveValue: { _ in }
        )
        XCTAssertEqual(error3, .foo, "Late subscriber should receive cached error")

        _ = [cancellable1, cancellable2, cancellable3, cancellable4, cancellable5, cancellable6]
    }

    func testPromise_setFailureType() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 success")

        let subject1 = PassthroughSubject<Int, Never>()
        let promise1 = subject1
            .assertPromise("testPromise_setFailureType: ")
            .setFailureType(to: MockError.self)

        var value1: Int?
        let cancellable1 = promise1.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
            receiveValue: { value1 = $0 }
        )

        subject1.send(42)
        subject1.send(completion: .finished)

        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .completed)
        XCTAssertEqual(value1, 42)

        _ = cancellable1
    }

    func testPromise_eraseFailureToError() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 success")

        let subject1 = PassthroughSubject<Int, MockError>()
        let promise1 = subject1
            .assertPromise("testPromise_eraseFailureToError: ")
            .eraseFailureToError()

        var value1: Int?
        let cancellable1 = promise1.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
            receiveValue: { value1 = $0 }
        )

        subject1.send(42)
        subject1.send(completion: .finished)

        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .completed)
        XCTAssertEqual(value1, 42)

        let expectationPromise2ReceiveCompletion = XCTestExpectation(description: "promise2 failure")
        let expectationPromise2ReceiveValue = XCTestExpectation(description: "promise2 does not receive value")

        let subject2 = PassthroughSubject<Int, MockError>()
        let promise2 = subject2
            .assertPromise("testPromise_eraseFailureToError: ")
            .eraseFailureToError()

        let cancellable2 = promise2.sink(
            receiveCompletion: {
                if case .failure(MockError.foo) = $0 { expectationPromise2ReceiveCompletion.fulfill() }
            },
            receiveValue: { _ in expectationPromise2ReceiveValue.fulfill() }
        )

        subject2.send(completion: .failure(.foo))

        let resultExpectationPromise2ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise2ReceiveCompletion], timeout: 0.1)
        let resultExpectationPromise2ReceiveValue = XCTWaiter.wait(for: [expectationPromise2ReceiveValue], timeout: 0.3)
        XCTAssertEqual(resultExpectationPromise2ReceiveCompletion, .completed)
        XCTAssertEqual(resultExpectationPromise2ReceiveValue, .timedOut, "Expectation was unexpectedly fulfilled")

        _ = cancellable1
        _ = cancellable2
    }

    func testPromise_run() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 success")

        let promise1 = Publishers.Promise<Int, MockError>(value: 42)

        var value1: Int?
        let cancellable1 = promise1.run(
            onSuccess: {
                value1 = $0
                expectationPromise1ReceiveCompletion.fulfill()
            },
            onFailure: { _ in }
        )

        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .completed)
        XCTAssertEqual(value1, 42)

        let expectationPromise2ReceiveCompletion = XCTestExpectation(description: "promise2 failure")

        let promise2 = Publishers.Promise<Int, MockError>(error: .foo)

        var error2: MockError?
        let cancellable2 = promise2.run(
            onSuccess: { _ in },
            onFailure: {
                error2 = $0
                expectationPromise2ReceiveCompletion.fulfill()
            }
        )

        let resultExpectationPromise2ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise2ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise2ReceiveCompletion, .completed)
        XCTAssertEqual(error2, .foo)

        let expectationPromise3ReceiveCompletion = XCTestExpectation(description: "promise3 void success")

        let promise3 = Publishers.Promise<Void, Never>(value: ())
        let cancellable3 = promise3.run {
            expectationPromise3ReceiveCompletion.fulfill()
        }

        let resultExpectationPromise3ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise3ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise3ReceiveCompletion, .completed)

        _ = cancellable1
        _ = cancellable2
        _ = cancellable3
    }

    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 8.0, *)
    func testPromise_asyncValue() async throws {
        let expectationPromise1ReceiveValue = XCTestExpectation(description: "promise1 success")
        
        // Success case
        let promise1 = Publishers.Promise<Int, Error>(value: 42)
        Task {
            do {
                let value = try await promise1.value()
                XCTAssertEqual(value, 42)
                expectationPromise1ReceiveValue.fulfill()
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
        
        let resultExpectationPromise1ReceiveValue = await XCTWaiter().fulfillment(of: [expectationPromise1ReceiveValue], timeout: 1.0)
        XCTAssertEqual(resultExpectationPromise1ReceiveValue, .completed)
        
        // Error case
        let expectationPromise2ReceiveError = XCTestExpectation(description: "promise2 error")
        
        let promise2 = Publishers.Promise<Int, Error>(error: MockError.foo)
        Task {
            do {
                _ = try await promise2.value()
                XCTFail("Expected error to be thrown")
            } catch {
                XCTAssertTrue(error is MockError)
                expectationPromise2ReceiveError.fulfill()
            }
        }
        
        let resultExpectationPromise2ReceiveError = await XCTWaiter().fulfillment(of: [expectationPromise2ReceiveError], timeout: 1.0)
        XCTAssertEqual(resultExpectationPromise2ReceiveError, .completed)
        
        // Cancellation case
        let expectationPromise3ReceiveCancellation = XCTestExpectation(description: "promise3 cancellation")
        
        let promise3 = Publishers.Promise<Int, Error> { _ in
            AnyCancellable { expectationPromise3ReceiveCancellation.fulfill() }
        }
        
        let task = Task {
            _ = try await promise3.value()
        }

        task.cancel()
        
        let resultExpectationPromise3ReceiveCancellation = await XCTWaiter().fulfillment(of: [expectationPromise3ReceiveCancellation], timeout: 1.0)
        XCTAssertEqual(resultExpectationPromise3ReceiveCancellation, .completed)
    }

    func testPromise_flatMapResult() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 success")
        
        let subject1 = PassthroughSubject<Int, MockError>()
        let promise1 = subject1
            .assertPromise("testPromise_flatMapResult: ")
            .flatMapResult { value -> Result<String, MockError> in
                .success(String(value))
            }
        
        var value1: String?
        let cancellable1 = promise1.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
            receiveValue: { value1 = $0 }
        )
        
        subject1.send(42)
        subject1.send(completion: .finished)
        
        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .completed)
        XCTAssertEqual(value1, "42")
        
        let expectationPromise2ReceiveCompletion = XCTestExpectation(description: "promise2 failure")
        let expectationPromise2ReceiveValue = XCTestExpectation(description: "promise2 does not receive value")
        
        let subject2 = PassthroughSubject<Int, MockError>()
        let promise2 = subject2
            .assertPromise("testPromise_flatMapResult: ")
            .flatMapResult { _ -> Result<String, MockError> in
                .failure(.foo)
            }
        
        let cancellable2 = promise2.sink(
            receiveCompletion: { if case .failure(MockError.foo) = $0 { expectationPromise2ReceiveCompletion.fulfill() } },
            receiveValue: { _ in expectationPromise2ReceiveValue.fulfill() }
        )
        
        subject2.send(42)
        
        let resultExpectationPromise2ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise2ReceiveCompletion], timeout: 0.1)
        let resultExpectationPromise2ReceiveValue = XCTWaiter.wait(for: [expectationPromise2ReceiveValue], timeout: 0.3)
        XCTAssertEqual(resultExpectationPromise2ReceiveCompletion, .completed)
        XCTAssertEqual(resultExpectationPromise2ReceiveValue, .timedOut, "Expectation was unexpectedly fulfilled")
        
        _ = cancellable1
        _ = cancellable2
    }

    func testPromise_fold() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 success")
        
        let subject1 = PassthroughSubject<Int, MockError>()
        let promise1 = subject1
            .assertPromise("testPromise_fold: ")
            .fold(
                onSuccess: { "Success: \($0)" },
                onFailure: { "Error: \($0)" }
            )
        
        var value1: String?
        let cancellable1 = promise1.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
            receiveValue: { value1 = $0 }
        )
        
        subject1.send(42)
        subject1.send(completion: .finished)
        
        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .completed)
        XCTAssertEqual(value1, "Success: 42")
        
        let expectationPromise2ReceiveCompletion = XCTestExpectation(description: "promise2 success with error fold")
        
        let subject2 = PassthroughSubject<Int, MockError>()
        let promise2 = subject2
            .assertPromise("testPromise_fold: ")
            .fold(
                onSuccess: { "Success: \($0)" },
                onFailure: { "Error: \($0)" }
            )
        
        var value2: String?
        let cancellable2 = promise2.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise2ReceiveCompletion.fulfill() } },
            receiveValue: { value2 = $0 }
        )
        
        subject2.send(completion: .failure(.foo))
        
        let resultExpectationPromise2ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise2ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise2ReceiveCompletion, .completed)
        XCTAssertEqual(value2, "Error: foo")
        
        _ = cancellable1
        _ = cancellable2
    }

    func testPromise_analysis() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 success")
        let expectationPromise1Analysis = XCTestExpectation(description: "promise1 analysis success")
        
        let subject1 = PassthroughSubject<Int, MockError>()
        let promise1 = subject1
            .assertPromise("testPromise_analysis: ")
            .analysis(
                ifSuccess: { _ in expectationPromise1Analysis.fulfill() },
                ifFailure: { _ in XCTFail("Unexpected error") }
            )
        
        let cancellable1 = promise1.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
            receiveValue: { _ in }
        )
        
        subject1.send(42)
        subject1.send(completion: .finished)
        
        let resultExpectations1 = XCTWaiter.wait(for: [
            expectationPromise1ReceiveCompletion,
            expectationPromise1Analysis
        ], timeout: 0.1)
        XCTAssertEqual(resultExpectations1, .completed)
        
        let expectationPromise2ReceiveCompletion = XCTestExpectation(description: "promise2 success")
        let expectationPromise2Analysis = XCTestExpectation(description: "promise2 analysis error")
        
        let subject2 = PassthroughSubject<Int, MockError>()
        let promise2 = subject2
            .assertPromise("testPromise_analysis: ")
            .analysis(
                ifSuccess: { _ in XCTFail("Unexpected success") },
                ifFailure: { _ in expectationPromise2Analysis.fulfill() }
            )
        
        let cancellable2 = promise2.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise2ReceiveCompletion.fulfill() } },
            receiveValue: { _ in }
        )
        
        subject2.send(completion: .failure(.foo))
        
        let resultExpectations2 = XCTWaiter.wait(for: [
            expectationPromise2ReceiveCompletion,
            expectationPromise2Analysis
        ], timeout: 0.1)
        XCTAssertEqual(resultExpectations2, .completed)
        
        _ = cancellable1
        _ = cancellable2
    }

    func testPromise_onError() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 success")
        let expectationPromise1OnError = XCTestExpectation(description: "promise1 onError not called")
        
        let subject1 = PassthroughSubject<Int, MockError>()
        let promise1 = subject1
            .assertPromise("testPromise_onError: ")
            .onError { _ in expectationPromise1OnError.fulfill() }
        
        var value1: Int?
        let cancellable1 = promise1.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
            receiveValue: { value1 = $0 }
        )
        
        subject1.send(42)
        subject1.send(completion: .finished)
        
        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 0.1)
        let resultExpectationPromise1OnError = XCTWaiter.wait(for: [expectationPromise1OnError], timeout: 0.3)
        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .completed)
        XCTAssertEqual(resultExpectationPromise1OnError, .timedOut, "OnError was unexpectedly called")
        XCTAssertEqual(value1, 42)
        
        let expectationPromise2ReceiveCompletion = XCTestExpectation(description: "promise2 failure")
        let expectationPromise2OnError = XCTestExpectation(description: "promise2 onError called")
        let expectationPromise2ReceiveValue = XCTestExpectation(description: "promise2 does not receive value")
        
        let subject2 = PassthroughSubject<Int, MockError>()
        let promise2 = subject2
            .assertPromise("testPromise_onError: ")
            .onError { error in
                XCTAssertEqual(error, .foo)
                expectationPromise2OnError.fulfill()
            }
        
        let cancellable2 = promise2.sink(
            receiveCompletion: { if case .failure(MockError.foo) = $0 { expectationPromise2ReceiveCompletion.fulfill() } },
            receiveValue: { _ in expectationPromise2ReceiveValue.fulfill() }
        )
        
        subject2.send(completion: .failure(.foo))
        
        let resultExpectations2 = XCTWaiter.wait(for: [
            expectationPromise2ReceiveCompletion,
            expectationPromise2OnError
        ], timeout: 0.1)
        let resultExpectationPromise2ReceiveValue = XCTWaiter.wait(for: [expectationPromise2ReceiveValue], timeout: 0.3)
        XCTAssertEqual(resultExpectations2, .completed)
        XCTAssertEqual(resultExpectationPromise2ReceiveValue, .timedOut, "Expectation was unexpectedly fulfilled")
        
        _ = cancellable1
        _ = cancellable2
    }

    func testPublisher_EraseToPromise_Empty() {
        let expectationPromise1Fallback = XCTestExpectation(description: "promise1 fallback executed")
        let expectationPromise1Hangs = XCTestExpectation(description: "promise1 hangs")
        let promise1 = Empty(completeImmediately: true, outputType: Void.self, failureType: MockError.self)
            .eraseToPromise(onEmpty: { expectationPromise1Fallback.fulfill(); return nil })

        let cancellable1 = promise1
            .sink(
                receiveCompletion: { _ in expectationPromise1Hangs.fulfill() },
                receiveValue: { expectationPromise1Hangs.fulfill() }
            )

        let resultExpectationPromise1Fallback = XCTWaiter.wait(for: [expectationPromise1Fallback], timeout: 0.1)
        let resultExpectationPromise1Hangs = XCTWaiter.wait(for: [expectationPromise1Hangs], timeout: 0.3)
        XCTAssertEqual(resultExpectationPromise1Fallback, .completed)
        XCTAssertEqual(resultExpectationPromise1Hangs, .timedOut, "Expectation was unexpectedly fulfilled")

        let expectationPromise2Fallback = XCTestExpectation(description: "promise2 fallback should not be executed")
        let expectationPromise2ReceiveCompletion = XCTestExpectation(description: "promise2 hangs")
        let expectationPromise2ReceiveValue = XCTestExpectation(description: "promise2 does not receive value")
        let promise2 = Empty(completeImmediately: false, outputType: Void.self, failureType: MockError.self)
            .eraseToPromise(onEmpty: { expectationPromise2Fallback.fulfill(); return nil })

        let cancellable2 = promise2
            .sink(
                receiveCompletion: { _ in expectationPromise2ReceiveCompletion.fulfill() },
                receiveValue: { expectationPromise2ReceiveValue.fulfill() }
            )

        let resultExpectationPromise2Fallback = XCTWaiter.wait(for: [expectationPromise2Fallback], timeout: 0.1)
        let resultExpectationPromise2ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise2ReceiveCompletion], timeout: 0.3)
        let resultExpectationPromise2ReceiveValue = XCTWaiter.wait(for: [expectationPromise2ReceiveValue], timeout: 0.3)
        XCTAssertEqual(resultExpectationPromise2Fallback, .timedOut, "Expectation was unexpectedly fulfilled")
        XCTAssertEqual(resultExpectationPromise2ReceiveCompletion, .timedOut, "Expectation was unexpectedly fulfilled")
        XCTAssertEqual(resultExpectationPromise2ReceiveValue, .timedOut, "Expectation was unexpectedly fulfilled")

        let expectationPromise3ReceiveCompletion = XCTestExpectation(description: "promise3 is completed")
        var value3: Int?
        let promise3 = Empty(completeImmediately: true, outputType: Int.self, failureType: MockError.self)
            .eraseToPromise(onEmpty: { return .success(1) })

        let cancellable3 = promise3
            .sink(
                receiveCompletion: { if case .finished = $0 { expectationPromise3ReceiveCompletion.fulfill() } },
                receiveValue: { value3 = $0 }
            )

        let resultExpectationPromise3ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise3ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise3ReceiveCompletion, .completed)
        XCTAssertEqual(value3, 1)

        let expectationPromise4ReceiveCompletion = XCTestExpectation(description: "promise4 is falied")
        let expectationPromise4ReceiveValue = XCTestExpectation(description: "promise4 does not receive value")
        let promise4 = Empty(completeImmediately: true, outputType: Void.self, failureType: MockError.self)
            .eraseToPromise(onEmpty: { return .failure(.foo) })

        let cancellable4 = promise4
            .sink(
                receiveCompletion: { if case .failure(.foo) = $0 { expectationPromise4ReceiveCompletion.fulfill() } },
                receiveValue: { expectationPromise4ReceiveValue.fulfill() }
            )

        let resultExpectationPromise4ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise4ReceiveCompletion], timeout: 0.1)
        let resultExpectationPromise4ReceiveValue = XCTWaiter.wait(for: [expectationPromise4ReceiveValue], timeout: 0.3)
        XCTAssertEqual(resultExpectationPromise4ReceiveCompletion, .completed)
        XCTAssertEqual(resultExpectationPromise4ReceiveValue, .timedOut, "Expectation was unexpectedly fulfilled")

        _ = cancellable1
        _ = cancellable2
        _ = cancellable3
        _ = cancellable4
    }

    func testPublisher_AssertPromise_Empty() throws {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 hangs")
        let expectationPromise1ReceiveValue = XCTestExpectation(description: "promise1 does not receive value")
        let promise1 = Empty(completeImmediately: false, outputType: Void.self, failureType: MockError.self)
            .assertPromise("testPublisher_AssertPromise_Empty: ")

        let cancellable1 = promise1
            .sink(
                receiveCompletion: { _ in expectationPromise1ReceiveCompletion.fulfill() },
                receiveValue: { expectationPromise1ReceiveValue.fulfill() }
            )

        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 0.3)
        let resultExpectationPromise1ReceiveValue = XCTWaiter.wait(for: [expectationPromise1ReceiveValue], timeout: 0.3)
        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .timedOut, "Expectation was unexpectedly fulfilled")
        XCTAssertEqual(resultExpectationPromise1ReceiveValue, .timedOut, "Expectation was unexpectedly fulfilled")

        _ = cancellable1

        throw XCTSkip("Expectation of below test case is fatalError, XCTest cannot assert against fatalError.")
        // let promise2 = Empty(completeImmediately: true, outputType: Void.self, failureType: MockError.self)
        //     .assertPromise("testPublisher_AssertPromise_Empty: ")
        //
        // let cancellable2 = promise2
        //     .sink(
        //         receiveCompletion: { _ in },
        //         receiveValue: { }
        //     )
        //
        // _ = cancellable2
    }

    func testPromise_EraseToPromise_CurrentValueSubject() {
        let expectationPromiseReceiveCompletion = XCTestExpectation(description: "promise is finished")
        let expectationPromiseFallback = XCTestExpectation(description: "promise fallback is not called")

        let subject = CurrentValueSubject<Int, MockError>(0)
        let promise = subject
            .eraseToPromise(onEmpty: { expectationPromiseFallback.fulfill(); return nil })
        var value: Int?

        let cancellable = promise
            .sink(
                receiveCompletion: { if case .finished = $0 { expectationPromiseReceiveCompletion.fulfill() } },
                receiveValue: { value = $0 }
            )

        let resultExpectationPromiseReceiveCompletion = XCTWaiter.wait(for: [expectationPromiseReceiveCompletion], timeout: 0.1)
        let resultExpectationPromiseFallback = XCTWaiter.wait(for: [expectationPromiseFallback], timeout: 0.3)
        XCTAssertEqual(resultExpectationPromiseReceiveCompletion, .completed)
        XCTAssertEqual(resultExpectationPromiseFallback, .timedOut, "Expectation was unexpectedly fulfilled")
        XCTAssertEqual(value, 0)

        _ = cancellable
    }

    func testPromise_EraseToPromise_PassthroughSubject() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 finished")
        let expectationPromise1Fallback = XCTestExpectation(description: "promise1 fallback is not called")

        let subject1 = PassthroughSubject<Int, MockError>()
        let promise1 = subject1
            .eraseToPromise(onEmpty: { expectationPromise1Fallback.fulfill(); return nil })
        var value1: Int?
        let cancellable1 = promise1
            .sink(
                receiveCompletion: { _ in expectationPromise1ReceiveCompletion.fulfill() },
                receiveValue: { value1 = $0 }
            )

        subject1.send(1)
        subject1.send(2)

        let resultExpectationPromise1Fallback = XCTWaiter.wait(for: [expectationPromise1Fallback], timeout: 0.3)
        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 0.3)
        XCTAssertEqual(resultExpectationPromise1Fallback, .timedOut, "Expectation was unexpectedly fulfilled")
        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .completed)
        XCTAssertEqual(value1, 1)

        let expectationPromise2ReceiveCompletion = XCTestExpectation(description: "promise2 is finished")
        let expectationPromise2Fallback = XCTestExpectation(description: "promise2 fallback is not called")
        let expectationPromise2ReceiveValue = XCTestExpectation(description: "promise2 didnt receive any value")

        let subject2 = PassthroughSubject<Void, MockError>()
        let promise2 = subject2
            .eraseToPromise(onEmpty: { expectationPromise2Fallback.fulfill(); return .success(()) })

        let cancellable2 = promise2
            .sink(
                receiveCompletion: { if case .failure(.foo) = $0 { expectationPromise2ReceiveCompletion.fulfill() } },
                receiveValue: { expectationPromise2ReceiveValue.fulfill() }
            )

        subject2.send(completion: .failure(.foo))
        subject2.send(())

        let resultExpectationPromise2Fallback = XCTWaiter.wait(for: [expectationPromise2Fallback], timeout: 0.3)
        let resultExpectationPromise2ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise2ReceiveCompletion], timeout: 0.1)
        let resultExpectationPromise2ReceiveValue = XCTWaiter.wait(for: [expectationPromise2ReceiveValue], timeout: 0.3)
        XCTAssertEqual(resultExpectationPromise2Fallback, .timedOut, "Expectation was unexpectedly fulfilled")
        XCTAssertEqual(resultExpectationPromise2ReceiveCompletion, .completed)
        XCTAssertEqual(resultExpectationPromise2ReceiveValue, .timedOut, "Expectation was unexpectedly fulfilled")

        let expectationPromise3ReceiveCompletion = XCTestExpectation(description: "promise3 is finished")
        let expectationPromise3Fallback = XCTestExpectation(description: "promise3 fallback is not called")
        let expectationPromise3ReceiveValue = XCTestExpectation(description: "promise3 received value")
        let expectationPromise4ReceiveCompletion = XCTestExpectation(description: "promise4 is finished")
        let expectationPromise4Fallback = XCTestExpectation(description: "promise4 fallback is not called")
        let expectationPromise4ReceiveValue = XCTestExpectation(description: "promise4 receive value")

        let subject3 = PassthroughSubject<Void, MockError>()
        let promise3 = subject3
            .eraseToAnyPublisher()
            .eraseToPromise(onEmpty: { expectationPromise3Fallback.fulfill(); return .success(()) })
        let promise4 = subject3
            .eraseToAnyPublisher()
            .eraseToPromise(onEmpty: { expectationPromise4Fallback.fulfill(); return .success(()) })

        let cancellable3 = promise3
            .sink(
                receiveCompletion: { if case .finished = $0 { expectationPromise3ReceiveCompletion.fulfill() } },
                receiveValue: { expectationPromise3ReceiveValue.fulfill() }
            )

        subject3.send(())

        let cancellable4 = promise4
            .sink(
                receiveCompletion: { if case .finished = $0 { expectationPromise4ReceiveCompletion.fulfill() } },
                receiveValue: { expectationPromise4ReceiveValue.fulfill() }
            )

        subject3.send(())

        let resultExpectationPromise3Fallback = XCTWaiter.wait(for: [expectationPromise3Fallback], timeout: 0.3)
        let resultExpectationPromise3ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise3ReceiveCompletion], timeout: 0.1)
        let resultExpectationPromise3ReceiveValue = XCTWaiter.wait(for: [expectationPromise3ReceiveValue], timeout: 0.1)
        let resultExpectationPromise4Fallback = XCTWaiter.wait(for: [expectationPromise4Fallback], timeout: 0.3)
        let resultExpectationPromise4ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise4ReceiveCompletion], timeout: 0.1)
        let resultExpectationPromise4ReceiveValue = XCTWaiter.wait(for: [expectationPromise4ReceiveValue], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise3Fallback, .timedOut, "Expectation was unexpectedly fulfilled")
        XCTAssertEqual(resultExpectationPromise3ReceiveCompletion, .completed)
        XCTAssertEqual(resultExpectationPromise3ReceiveValue, .completed)
        XCTAssertEqual(resultExpectationPromise4Fallback, .timedOut, "Expectation was unexpectedly fulfilled")
        XCTAssertEqual(resultExpectationPromise4ReceiveCompletion, .completed)
        XCTAssertEqual(resultExpectationPromise4ReceiveValue, .completed)

        _ = cancellable1
        _ = cancellable2
        _ = cancellable3
        _ = cancellable4
    }

    func testPromise_validStatusCode() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 success")
        
        let subject1 = PassthroughSubject<(data: Data, response: URLResponse), URLError>()
        let promise1 = subject1
            .assertPromise("testPromise_validStatusCode: ")
            .validStatusCode()
        
        let cancellable1 = promise1.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
            receiveValue: { }
        )
        
        let response1 = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        subject1.send((data: Data(), response: response1))
        subject1.send(completion: .finished)
        
        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .completed)
        
        // Test invalid HTTP status code
        let expectationPromise2ReceiveCompletion = XCTestExpectation(description: "promise2 failure")
        let expectationPromise2ReceiveValue = XCTestExpectation(description: "promise2 does not receive value")
        
        let subject2 = PassthroughSubject<(data: Data, response: URLResponse), URLError>()
        let promise2 = subject2
            .assertPromise("testPromise_validStatusCode: ")
            .validStatusCode()
        
        let cancellable2 = promise2.sink(
            receiveCompletion: { if case .failure(URLError.badServerResponse) = $0 { expectationPromise2ReceiveCompletion.fulfill() } },
            receiveValue: { _ in expectationPromise2ReceiveValue.fulfill() }
        )
        
        let response2 = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )!
        subject2.send((data: Data(), response: response2))
        
        let resultExpectationPromise2ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise2ReceiveCompletion], timeout: 0.1)
        let resultExpectationPromise2ReceiveValue = XCTWaiter.wait(for: [expectationPromise2ReceiveValue], timeout: 0.3)
        XCTAssertEqual(resultExpectationPromise2ReceiveCompletion, .completed)
        XCTAssertEqual(resultExpectationPromise2ReceiveValue, .timedOut, "Expectation was unexpectedly fulfilled")
        
        // Test non-HTTP response
        let expectationPromise3ReceiveCompletion = XCTestExpectation(description: "promise3 failure")
        let expectationPromise3ReceiveValue = XCTestExpectation(description: "promise3 does not receive value")
        
        let subject3 = PassthroughSubject<(data: Data, response: URLResponse), URLError>()
        let promise3 = subject3
            .assertPromise("testPromise_validStatusCode: ")
            .validStatusCode()
        
        let cancellable3 = promise3.sink(
            receiveCompletion: { if case .failure(URLError.badServerResponse) = $0 { expectationPromise3ReceiveCompletion.fulfill() } },
            receiveValue: { _ in expectationPromise3ReceiveValue.fulfill() }
        )
        
        let response3 = URLResponse(
            url: URL(string: "https://example.com")!,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        subject3.send((data: Data(), response: response3))
        
        let resultExpectationPromise3ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise3ReceiveCompletion], timeout: 0.1)
        let resultExpectationPromise3ReceiveValue = XCTWaiter.wait(for: [expectationPromise3ReceiveValue], timeout: 0.3)
        XCTAssertEqual(resultExpectationPromise3ReceiveCompletion, .completed)
        XCTAssertEqual(resultExpectationPromise3ReceiveValue, .timedOut, "Expectation was unexpectedly fulfilled")
        
        _ = cancellable1
        _ = cancellable2
        _ = cancellable3
    }

    func testPromise_replaceNil() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 success")
        
        let subject1 = PassthroughSubject<Int?, MockError>()
        let promise1 = subject1
            .assertPromise("testPromise_replaceNil: ")
            .replaceNil(with: 42)
        
        var value1: Int?
        let cancellable1 = promise1.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
            receiveValue: { value1 = $0 }
        )
        
        subject1.send(nil)
        subject1.send(completion: .finished)
        
        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .completed)
        XCTAssertEqual(value1, 42)
        
        _ = cancellable1
    }

    func testPromise_replaceError() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 success")
        
        let subject1 = PassthroughSubject<Int, MockError>()
        let promise1 = subject1
            .assertPromise("testPromise_replaceError: ")
            .replaceError(with: 42)
        
        var value1: Int?
        let cancellable1 = promise1.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
            receiveValue: { value1 = $0 }
        )
        
        subject1.send(completion: .failure(.foo))
        
        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .completed)
        XCTAssertEqual(value1, 42)
        
        _ = cancellable1
    }

    func testPromise_contains() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 success")
        
        let subject1 = PassthroughSubject<Int, MockError>()
        let promise1 = subject1
            .assertPromise("testPromise_contains: ")
            .contains { $0 == 42 }
        
        var value1: Bool?
        let cancellable1 = promise1.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
            receiveValue: { value1 = $0 }
        )
        
        subject1.send(42)
        subject1.send(completion: .finished)
        
        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .completed)
        XCTAssertEqual(value1, true)
        
        let expectationPromise2ReceiveCompletion = XCTestExpectation(description: "promise2 success")
        
        let subject2 = PassthroughSubject<Int, MockError>()
        let promise2 = subject2
            .assertPromise("testPromise_contains: ")
            .contains { $0 == 42 }
        
        var value2: Bool?
        let cancellable2 = promise2.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise2ReceiveCompletion.fulfill() } },
            receiveValue: { value2 = $0 }
        )
        
        subject2.send(1)
        subject2.send(completion: .finished)
        
        let resultExpectationPromise2ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise2ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise2ReceiveCompletion, .completed)
        XCTAssertEqual(value2, false)
        
        _ = cancellable1
        _ = cancellable2
    }

    func testPromise_tryContains() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 success")
        
        let subject1 = PassthroughSubject<Int, MockError>()
        let promise1 = subject1
            .assertPromise("testPromise_tryContains: ")
            .tryContains { value -> Bool in
                if value < 0 { throw MockError.foo }
                return value == 42
            }
        
        var value1: Bool?
        let cancellable1 = promise1.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
            receiveValue: { value1 = $0 }
        )
        
        subject1.send(42)
        subject1.send(completion: .finished)
        
        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .completed)
        XCTAssertEqual(value1, true)
        
        let expectationPromise2ReceiveCompletion = XCTestExpectation(description: "promise2 failure")
        let expectationPromise2ReceiveValue = XCTestExpectation(description: "promise2 does not receive value")
        
        let subject2 = PassthroughSubject<Int, MockError>()
        let promise2 = subject2
            .assertPromise("testPromise_tryContains: ")
            .tryContains { value -> Bool in
                if value < 0 { throw MockError.foo }
                return value == 42
            }
        
        let cancellable2 = promise2.sink(
            receiveCompletion: { if case .failure = $0 { expectationPromise2ReceiveCompletion.fulfill() } },
            receiveValue: { _ in expectationPromise2ReceiveValue.fulfill() }
        )
        
        subject2.send(-1)
        
        let resultExpectationPromise2ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise2ReceiveCompletion], timeout: 0.1)
        let resultExpectationPromise2ReceiveValue = XCTWaiter.wait(for: [expectationPromise2ReceiveValue], timeout: 0.3)
        XCTAssertEqual(resultExpectationPromise2ReceiveCompletion, .completed)
        XCTAssertEqual(resultExpectationPromise2ReceiveValue, .timedOut, "Expectation was unexpectedly fulfilled")
        
        _ = cancellable1
        _ = cancellable2
    }

    func testPromise_encode() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 success")
        
        struct TestModel: Codable, Equatable {
            let value: Int
        }
        
        let subject1 = PassthroughSubject<TestModel, MockError>()
        let promise1 = subject1
            .assertPromise("testPromise_encode: ")
            .encode(encoder: JSONEncoder())
        
        var value1: Data?
        let cancellable1 = promise1.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
            receiveValue: { value1 = $0 }
        )
        
        subject1.send(TestModel(value: 42))
        subject1.send(completion: .finished)
        
        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .completed)
        
        let decoder = JSONDecoder()
        let decodedModel = try? decoder.decode(TestModel.self, from: value1 ?? Data())
        XCTAssertEqual(decodedModel, TestModel(value: 42))
        
        _ = cancellable1
    }

    func testPromise_decode() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 success")
        
        struct TestModel: Codable, Equatable {
            let value: Int
        }
        
        let subject1 = PassthroughSubject<Data, MockError>()
        let promise1 = subject1
            .assertPromise("testPromise_decode: ")
            .decode(type: TestModel.self, decoder: JSONDecoder())
        
        var value1: TestModel?
        let cancellable1 = promise1.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
            receiveValue: { value1 = $0 }
        )
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(TestModel(value: 42))
        subject1.send(data)
        subject1.send(completion: .finished)
        
        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .completed)
        XCTAssertEqual(value1, TestModel(value: 42))

        let expectationPromise2ReceiveCompletion = XCTestExpectation(description: "promise2 failure")
        let expectationPromise2ReceiveValue = XCTestExpectation(description: "promise2 does not receive value")
        
        let subject2 = PassthroughSubject<Data, MockError>()
        let promise2 = subject2
            .assertPromise("testPromise_decode: ")
            .decode(type: TestModel.self, decoder: JSONDecoder())
        
        let cancellable2 = promise2.sink(
            receiveCompletion: { if case .failure = $0 { expectationPromise2ReceiveCompletion.fulfill() } },
            receiveValue: { _ in expectationPromise2ReceiveValue.fulfill() }
        )
        
        subject2.send(Data("invalid json".utf8))
        
        let resultExpectationPromise2ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise2ReceiveCompletion], timeout: 0.1)
        let resultExpectationPromise2ReceiveValue = XCTWaiter.wait(for: [expectationPromise2ReceiveValue], timeout: 0.3)
        XCTAssertEqual(resultExpectationPromise2ReceiveCompletion, .completed)
        XCTAssertEqual(resultExpectationPromise2ReceiveValue, .timedOut, "Expectation was unexpectedly fulfilled")
        
        _ = cancellable1
        _ = cancellable2
    }

    func testPromise_flatMap() {
        let expectationPromise1ReceiveCompletion = XCTestExpectation(description: "promise1 success")
        
        let subject1 = PassthroughSubject<Int, Never>()
        let promise1 = subject1
            .assertPromise("testPromise_flatMap: ")
            .flatMap { value -> Publishers.Promise<String, MockError> in
                .init(value: String(value))
            }
        
        var value1: String?
        let cancellable1 = promise1.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise1ReceiveCompletion.fulfill() } },
            receiveValue: { value1 = $0 }
        )
        
        subject1.send(42)
        subject1.send(completion: .finished)
        
        let resultExpectationPromise1ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise1ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise1ReceiveCompletion, .completed)
        XCTAssertEqual(value1, "42")

        let expectationPromise2ReceiveCompletion = XCTestExpectation(description: "promise2 upstream failure")
        let expectationPromise2ReceiveValue = XCTestExpectation(description: "promise2 does not receive value")
        
        let subject2 = PassthroughSubject<Int, MockError>()
        let promise2 = subject2
            .assertPromise("testPromise_flatMap: ")
            .flatMap { value -> Publishers.Promise<String, Never> in
                .init(value: String(value))
            }
        
        let cancellable2 = promise2.sink(
            receiveCompletion: { if case .failure(MockError.foo) = $0 { expectationPromise2ReceiveCompletion.fulfill() } },
            receiveValue: { _ in expectationPromise2ReceiveValue.fulfill() }
        )
        
        subject2.send(completion: .failure(.foo))
        
        let resultExpectationPromise2ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise2ReceiveCompletion], timeout: 0.1)
        let resultExpectationPromise2ReceiveValue = XCTWaiter.wait(for: [expectationPromise2ReceiveValue], timeout: 0.3)
        XCTAssertEqual(resultExpectationPromise2ReceiveCompletion, .completed)
        XCTAssertEqual(resultExpectationPromise2ReceiveValue, .timedOut, "Expectation was unexpectedly fulfilled")

        let expectationPromise3ReceiveCompletion = XCTestExpectation(description: "promise3 transform failure")
        
        let subject3 = PassthroughSubject<Int, Never>()
        let promise3 = subject3
            .assertPromise("testPromise_flatMap: ")
            .flatMap { int -> Publishers.Promise<String, Never> in
                    .init(value: String(int))
            }

        var value3: String?
        let cancellable3 = promise3.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise3ReceiveCompletion.fulfill() } },
            receiveValue: { value3 = $0 }
        )
        
        subject3.send(42)
        
        let resultExpectationPromise3ReceiveCompletion = XCTWaiter.wait(for: [expectationPromise3ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectationPromise3ReceiveCompletion, .completed)
        XCTAssertEqual(value3, "42")

        let expectationPromise4Operation = XCTestExpectation(description: "promise4 operation executed")
        let expectationPromise4Cancellation = XCTestExpectation(description: "promise4 cancelled")

        let subject4 = PassthroughSubject<Int, MockError>()
        let promise4 = subject4
            .assertPromise("testPromise_flatMap: ")
            .flatMap { _ -> Publishers.Promise<String, MockError> in
                Publishers.Promise { _ in
                    expectationPromise4Operation.fulfill()
                    return AnyCancellable {
                        expectationPromise4Cancellation.fulfill()
                    }
                }
            }
        
        let cancellable4 = promise4.sink(
            receiveCompletion: { _ in },
            receiveValue: { _ in }
        )
        
        subject4.send(42)
        cancellable4.cancel()

        let resultExpectations4 = XCTWaiter.wait(for: [
            expectationPromise4Operation,
            expectationPromise4Cancellation
        ], timeout: 0.1)
        XCTAssertEqual(resultExpectations4, .completed)

        let expectationPromise5ReceiveCompletion = XCTestExpectation(description: "promise5 completed")
        var value5 = ""

        let subject5 = PassthroughSubject<Int, MockError>()
        let promise5 = subject5
            .assertPromise("testPromise_flatMap: ")
            .flatMap { _ -> AnyPublisher<String, MockError> in
                Publishers.Promise(value: "42")
                    .eraseToAnyPublisher()
            }

        let cancellable5 = promise5.sink(
            receiveCompletion: { if case .finished = $0 { expectationPromise5ReceiveCompletion.fulfill() } },
            receiveValue: { value5 = $0 }
        )

        subject5.send(42)


        let resultExpectations5 = XCTWaiter.wait(for: [expectationPromise5ReceiveCompletion], timeout: 0.1)
        XCTAssertEqual(resultExpectations5, .completed)
        XCTAssertEqual(value5, "42")

        let _: AnyPublisher<String, MockError> = PassthroughSubject<Int, MockError>()
            .assertPromise("testPromise_flatMap: ")
            .flatMap { _ -> AnyPublisher<String, Never> in
                Publishers.Promise(value: "42")
                    .eraseToAnyPublisher()
            }

        let _: AnyPublisher<String, MockError> = PassthroughSubject<Int, Never>()
            .assertPromise("testPromise_flatMap: ")
            .flatMap { _ -> AnyPublisher<String, MockError> in
                Publishers.Promise(value: "42")
                    .eraseToAnyPublisher()
            }

        // Update the cancellables array at the end
        _ = [cancellable1, cancellable2, cancellable3, cancellable4, cancellable5]
    }
}

fileprivate enum MockError: Error, Sendable {
    case foo
}

fileprivate final class Atomic<Value>: @unchecked Sendable {
    private var _value: Value
    private let lock = NSLock()
    var value: Value { withLock { $0 } }

    init(_ value: Value) {
        self._value = value
    }

    func withLock<T>(_ operation: (inout Value) throws -> T) rethrows -> T {
        lock.lock()
        defer { lock.unlock() }
        return try operation(&_value)
    }
}
