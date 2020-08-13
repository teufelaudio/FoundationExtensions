//
//  Publishers+PrependLatestTests.swift
//  FoundationExtensionsTests
//
//  Created by Thomas Mellenthin on 22.07.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

#if !os(watchOS) && canImport(Combine)

import FoundationExtensions
import Combine
import XCTest

class PublishersPrependLatestTests: XCTestCase {
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, OSX 10.15, *)
extension PublishersPrependLatestTests {

    func testFirstEmptyThenBothvalue() {
        // given
        let first = PassthroughSubject<String, Never>()
        let second = PassthroughSubject<String, Never>()
        var events: [(String, String)] = []

        let cancellable = Publishers.CombineLatest(first, second)
            .prependLatest(Just(("empty", "empty")))
            .sink { events.append($0) }

        // when
        first.send("a")
        second.send("b")

        // then
        XCTAssertEqual(events.count, 3)
        XCTAssertTrue(events[0] == ("empty", "empty"))
        XCTAssertTrue(events[1] == ("a", "empty"))
        XCTAssertTrue(events[2] == ("a", "b"))

        // arc
        cancellable.cancel()
    }

    func testFirstEmptyThenOnlyTheFirstValue() {
        // given
        let first = PassthroughSubject<String, Never>()
        let second = PassthroughSubject<String, Never>()
        var events: [(String, String)] = []

        let cancellable = Publishers.CombineLatest(first, second)
            .prependLatest(Just(("empty", "empty")))
            .sink { events.append($0) }

        // when - send only a
        first.send("a")


        // then
        XCTAssertEqual(events.count, 2)
        XCTAssertTrue(events[0] == ("empty", "empty"))
        XCTAssertTrue(events[1] == ("a", "empty"))

        // arc
        cancellable.cancel()
    }

    func testFirstEmptyThenOnlyTheSecondValue() {
        // given
        let first = PassthroughSubject<String, Never>()
        let second = PassthroughSubject<String, Never>()
        var events: [(String, String)] = []

        let cancellable = Publishers.CombineLatest(first, second)
            .prependLatest(Just(("empty", "empty")))
            .sink { events.append($0) }

        // when - send only b
        second.send("b")


        // then
        XCTAssertEqual(events.count, 2)
        XCTAssertTrue(events[0] == ("empty", "empty"))
        XCTAssertTrue(events[1] == ("empty", "b"))

        // arc
        cancellable.cancel()
    }

    func testFirstEmptyAndNoOtherEvents() {
        // given
        let first = PassthroughSubject<String, Never>()
        let second = PassthroughSubject<String, Never>()
        var events: [(String, String)] = []

        let cancellable = Publishers.CombineLatest(first, second)
            .prependLatest(Just(("empty", "empty")))
            .sink { events.append($0) }

        // when - do nothing

        // then
        XCTAssertEqual(events.count, 1)
        XCTAssertTrue(events[0] == ("empty", "empty"))

        // arc
        cancellable.cancel()
    }
}
#endif
