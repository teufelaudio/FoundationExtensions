// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if !os(watchOS) && canImport(Combine)
import FoundationExtensions
import Combine
import XCTest

class PublishersCombineLatestTests: XCTestCase {
}

extension PublishersCombineLatestTests {

    @available(iOS 13.0, *)
    func testCombineLatest5() {
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

    @available(iOS 13.0, *)
    func testCombineLatest6() {
        // given
        let a = PassthroughSubject<String, Never>()
        let b = PassthroughSubject<String, Never>()
        let c = PassthroughSubject<String, Never>()
        let d = PassthroughSubject<String, Never>()
        let e = PassthroughSubject<String, Never>()
        let f = PassthroughSubject<String, Never>()
        var events: [(String, String, String, String, String, String)] = []

        let cancellable = Publishers.CombineLatest6(a, b, c, d, e, f)
            .sink { events.append($0) }

        // when
        a.send("a")
        b.send("b")
        c.send("c")
        d.send("d")
        e.send("e")
        f.send("f")

        b.send("bb")
        c.send("cc")
        b.send("bbb")

        // then
        XCTAssertEqual(events.count, 4)
        XCTAssertTrue(events[0] == ("a", "b",   "c",  "d", "e", "f"))
        XCTAssertTrue(events[1] == ("a", "bb",  "c",  "d", "e", "f"))
        XCTAssertTrue(events[2] == ("a", "bb",  "cc", "d", "e", "f"))
        XCTAssertTrue(events[3] == ("a", "bbb", "cc", "d", "e", "f"))

        // arc
        cancellable.cancel()
    }
}

#endif
