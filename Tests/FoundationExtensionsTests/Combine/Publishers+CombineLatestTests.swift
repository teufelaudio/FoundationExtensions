//
//  Publishers+CombineLatest.swift
//  FoundationExtensionsTests
//
//  Created by Thomas Mellenthin on 22.07.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

#if !os(watchOS) && canImport(Combine)
import FoundationExtensions
import Combine
import XCTest

class PublishersCombineLatestTests: XCTestCase {
}

extension PublishersCombineLatestTests {

    @available(iOS 13.0, *)
    func testFirstEmptyThenBothvalue() {
        // given
        let a = PassthroughSubject<String, Never>()
        let b = PassthroughSubject<String, Never>()
        let c = PassthroughSubject<String, Never>()
        let d = PassthroughSubject<String, Never>()
        let e = PassthroughSubject<String, Never>()
        var events: [(String, String, String, String, String)] = []

        let cancellable = Publishers.CombineLatest5(a, b, c, d, e)
            .sink { events.append($0) }

        // when
        a.send("a")
        b.send("b")
        c.send("c")
        d.send("d")
        e.send("e")

        b.send("bb")
        c.send("cc")
        b.send("bbb")

        // then
        XCTAssertEqual(events.count, 4)
        XCTAssertTrue(events[0] == ("a", "b",   "c",  "d", "e"))
        XCTAssertTrue(events[1] == ("a", "bb",  "c",  "d", "e"))
        XCTAssertTrue(events[2] == ("a", "bb",  "cc", "d", "e"))
        XCTAssertTrue(events[3] == ("a", "bbb", "cc", "d", "e"))

        // arc
        cancellable.cancel()
    }
}

#endif
