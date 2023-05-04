// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if !os(watchOS) && canImport(Combine)
import FoundationExtensions
import Combine
import XCTest

@available(macOS 10.15, iOS 13.0, tvOS 15.0, watchOS 6.0, *)
class PublishersCombineValuesTests: XCTestCase {
    func test_AsyncStream_WhenCurrentValueSubjectPublishesInt1_StreamPublishesInt1() async throws {
        // given
        let testStore = TestStore<Int?>(nil)
        let result = 1
        let publisher = CurrentValueSubject<Int?, Never>(nil)
        _ = Task {
            for try await value in publisher.stream {
                await testStore.setValue(value)
            }
        }
        
        // when
        publisher.send(result)
        
        // then
        try await then
        let receivedValue = await testStore.value
        XCTAssertEqual(receivedValue, result)
    }
    
    func test_AsyncStream_WhenCurrentValueSubjectFinishes_StreamReturnsVoid() async {
        // given
        let publisher = CurrentValueSubject<Int?, Never>(nil)
        let sut = Task {
            for await _ in publisher.stream { }
        }
        
        // when
        publisher.send(completion: .finished)
        
        // then
        let isCompletionSuccessful = await sut.result.isSuccess
        XCTAssertTrue(isCompletionSuccessful)
    }
    
    func test_AsyncThrowingStream_WhenCurrentValueSubjectPublishesInt1_StreamPublishesInt1() async throws {
        // given
        let testStore = TestStore<Int?>(nil)
        let result = 1
        let publisher = CurrentValueSubject<Int?, Error>(nil)
        _ = Task {
            for try await value in publisher.stream {
                await testStore.setValue(value)
            }
        }
        
        // when
        publisher.send(result)
        
        // then
        try await then
        let receivedValue = await testStore.value
        XCTAssertEqual(receivedValue, result)
    }
    
    func test_AsyncThrowingStream_WhenCurrentValueSubjectFinishesWithError_StreamThrows() async {
        // given
        let result = TestFailure.foo
        let publisher = CurrentValueSubject<Int?, Error>(nil)
        let sut = Task {
            for try await _ in publisher.stream { }
        }
        
        // when
        publisher.send(completion: .failure(TestFailure.foo))
        
        // then
        let error = await returnError { try await sut.value } as? TestFailure
        XCTAssertEqual(error, result)
    }
    
    func test_AsyncThrowingStream_WhenCurrentValueSubjectFinishes_StreamReturnsVoid() async {
        // given
        let publisher = CurrentValueSubject<Int?, Error>(nil)
        let sut = Task {
            for try await _ in publisher.stream { }
        }
        
        // when
        publisher.send(completion: .finished)
        
        // then
        let isCompletionSuccessful = await sut.result.isSuccess
        XCTAssertTrue(isCompletionSuccessful)
    }
}

// MARK: - Helpers
private enum TestFailure: Error, Equatable {
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

// This is necessary to sync tasks from background threads.
// `actor` will queue all write / read process from any thread.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private actor TestStore<V> {
    private(set) var value: V
    init(_ value: V) { self.value = value }
    func setValue(_ value: V) {
        self.value = value
    }
}

// Workaround!
// This is needed before accessing actor's property otherwise we can't get updated value.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private var then: Void {
    get async throws {
        try await Task.sleep(nanoseconds: 0)
    }
}
#endif
