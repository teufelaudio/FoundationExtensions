// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if !os(watchOS)
import Foundation
import FoundationExtensions
import XCTest

extension String: Mergeable {
    public static func merge(_ lhs: String, _ rhs: String) -> String {
        lhs + rhs
    }
}

extension Array: Mergeable {
    public static func merge(_ lhs: Array, _ rhs: Array) -> Array {
        lhs + rhs
    }
}

struct User: Identifiable, Equatable {
    let id: Int
    let name: String
}

struct Device: Identifiable, Equatable, Mergeable {
    let id: Int
    let name: String
    let ip: [String]

    static func merge(_ lhs: Device, _ rhs: Device) -> Device {
        Device(id: lhs.id, name: lhs.name, ip: lhs.ip + rhs.ip)
    }
}

class UniqueTests: XCTestCase {
    func testMergeable() {
        XCTAssertEqual("ab", "a".merge(with: "b"))
        XCTAssertEqual("abc", "a".merge(with: "b").merge(with: "c"))
        XCTAssertEqual("abc", "a".merge(with: "b".merge(with: "c")))

        XCTAssertEqual(["a", "b"], ["a"].merge(with: ["b"]))
        XCTAssertEqual(["a", "b", "c"], ["a"].merge(with: ["b"]).merge(with: ["c"]))
        XCTAssertEqual(["a", "b", "c"], ["a"].merge(with: ["b"].merge(with: ["c"])))
    }
}

extension UniqueTests {
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func testArrayAppendUniqueWithCustomFunction() {
        // given
        var users = [User(id: 1, name: "A")]
        let merge: (User, User) -> User = { User(id: $0.id, name: $0.name + " " + $1.name) }

        // when
        users.append(unique: User(id: 2, name: "B"), merging: merge)
        users.append(unique: User(id: 1, name: "C"), merging: merge)
        users.append(unique: User(id: 2, name: "D"), merging: merge)
        users.append(unique: User(id: 3, name: "E"), merging: merge)
        users.append(unique: User(id: 1, name: "F"), merging: merge)

        // then
        XCTAssertEqual(
            [
                User(id: 1, name: "A C F"),
                User(id: 2, name: "B D"),
                User(id: 3, name: "E")
            ],
            users
        )
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func testArrayAppendUniqueWithCustomFunctionIgnoringRight() {
        // given
        var users = [User(id: 1, name: "A")]
        let merge: (User, User) -> User = { l, _ in l }

        // when
        users.append(unique: User(id: 2, name: "B"), merging: merge)
        users.append(unique: User(id: 1, name: "C"), merging: merge)
        users.append(unique: User(id: 2, name: "D"), merging: merge)
        users.append(unique: User(id: 3, name: "E"), merging: merge)
        users.append(unique: User(id: 1, name: "F"), merging: merge)

        // then
        XCTAssertEqual(
            [
                User(id: 1, name: "A"),
                User(id: 2, name: "B"),
                User(id: 3, name: "E")
            ],
            users
        )
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func testArrayAppendUniqueWithCustomFunctionIgnoringLeft() {
        // given
        var users = [User(id: 1, name: "A")]
        let merge: (User, User) -> User = { _, r in r }

        // when
        users.append(unique: User(id: 2, name: "B"), merging: merge)
        users.append(unique: User(id: 1, name: "C"), merging: merge)
        users.append(unique: User(id: 2, name: "D"), merging: merge)
        users.append(unique: User(id: 3, name: "E"), merging: merge)
        users.append(unique: User(id: 1, name: "F"), merging: merge)

        // then
        XCTAssertEqual(
            [
                User(id: 1, name: "F"),
                User(id: 2, name: "D"),
                User(id: 3, name: "E")
            ],
            users
        )
    }
}

extension UniqueTests {
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func testArrayAppendUniqueWithMergeable() {
        // given
        var devices = [Device(id: 1, name: "A", ip: ["127.0.0.1"])]

        // when
        devices.append(unique: Device(id: 2, name: "B", ip: ["192.168.0.1"]))
        devices.append(unique: Device(id: 1, name: "C", ip: ["172.0.2.1"]))
        devices.append(unique: Device(id: 2, name: "D", ip: ["201.202.0.203"]))
        devices.append(unique: Device(id: 3, name: "E", ip: ["2.0.0.2"]))
        devices.append(unique: Device(id: 1, name: "F", ip: ["10.5.4.3"]))

        // then
        XCTAssertEqual(
            [
                Device(id: 1, name: "A", ip: ["127.0.0.1", "172.0.2.1", "10.5.4.3"]),
                Device(id: 2, name: "B", ip: ["192.168.0.1", "201.202.0.203"]),
                Device(id: 3, name: "E", ip: ["2.0.0.2"])
            ],
            devices
        )
    }
}
#endif

#if !os(watchOS) && canImport(Combine)
import Combine
extension UniqueTests {
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func testCombineScanIntoUniqueArrayWithCustomFunction() {
        // given
        let upstream = PassthroughSubject<User, Never>()
        let merge: (User, User) -> User = { User(id: $0.id, name: $0.name + " " + $1.name) }
        var events: [[User]] = []
        let expectCompletion = expectation(description: "It should complete")

        // when
        let c = upstream
            .scanIntoUniqueArray(merging: merge)
            .sink(
                receiveCompletion: { _ in expectCompletion.fulfill() },
                receiveValue: { newList in
                    events.append(newList)
                }
            )

        upstream.send(User(id: 1, name: "A"))
        upstream.send(User(id: 2, name: "B"))
        upstream.send(User(id: 1, name: "C"))
        upstream.send(User(id: 2, name: "D"))
        upstream.send(User(id: 3, name: "E"))
        upstream.send(User(id: 1, name: "F"))

        upstream.send(completion: .finished)

        upstream.send(User(id: 1, name: "G"))

        // then

        wait(for: [expectCompletion], timeout: 0.1)

        XCTAssertEqual(
            [
                [User(id: 1, name: "A")],
                [User(id: 1, name: "A"), User(id: 2, name: "B")],
                [User(id: 1, name: "A C"), User(id: 2, name: "B")],
                [User(id: 1, name: "A C"), User(id: 2, name: "B D")],
                [User(id: 1, name: "A C"), User(id: 2, name: "B D"), User(id: 3, name: "E")],
                [User(id: 1, name: "A C F"), User(id: 2, name: "B D"), User(id: 3, name: "E")]
            ],
            events
        )

        XCTAssertNotNil(c)
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func testCombineScanIntoUniqueArrayWithCustomFunctionIgnoringRight() {
        // given
        let upstream = PassthroughSubject<User, Never>()
        let merge: (User, User) -> User = { l, _ in l }
        var events: [[User]] = []
        let expectCompletion = expectation(description: "It should complete")

        // when
        let c = upstream
            .scanIntoUniqueArray(merging: merge)
            .sink(
                receiveCompletion: { _ in expectCompletion.fulfill() },
                receiveValue: { newList in
                    events.append(newList)
                }
            )

        upstream.send(User(id: 1, name: "A"))
        upstream.send(User(id: 2, name: "B"))
        upstream.send(User(id: 1, name: "C"))
        upstream.send(User(id: 2, name: "D"))
        upstream.send(User(id: 3, name: "E"))
        upstream.send(User(id: 1, name: "F"))

        upstream.send(completion: .finished)

        upstream.send(User(id: 1, name: "G"))

        // then

        wait(for: [expectCompletion], timeout: 0.1)

        XCTAssertEqual(
            [
                [User(id: 1, name: "A")],
                [User(id: 1, name: "A"), User(id: 2, name: "B")],
                [User(id: 1, name: "A"), User(id: 2, name: "B")],
                [User(id: 1, name: "A"), User(id: 2, name: "B")],
                [User(id: 1, name: "A"), User(id: 2, name: "B"), User(id: 3, name: "E")],
                [User(id: 1, name: "A"), User(id: 2, name: "B"), User(id: 3, name: "E")]
            ],
            events
        )

        XCTAssertNotNil(c)
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func testCombineScanIntoUniqueArrayWithCustomFunctionIgnoringLeft() {
        // given
        let upstream = PassthroughSubject<User, Never>()
        let merge: (User, User) -> User = { _, r in r }
        var events: [[User]] = []
        let expectCompletion = expectation(description: "It should complete")

        // when
        let c = upstream
            .scanIntoUniqueArray(merging: merge)
            .sink(
                receiveCompletion: { _ in expectCompletion.fulfill() },
                receiveValue: { newList in
                    events.append(newList)
                }
            )

        upstream.send(User(id: 1, name: "A"))
        upstream.send(User(id: 2, name: "B"))
        upstream.send(User(id: 1, name: "C"))
        upstream.send(User(id: 2, name: "D"))
        upstream.send(User(id: 3, name: "E"))
        upstream.send(User(id: 1, name: "F"))

        upstream.send(completion: .finished)

        upstream.send(User(id: 1, name: "G"))

        // then

        wait(for: [expectCompletion], timeout: 0.1)

        XCTAssertEqual(
            [
                [User(id: 1, name: "A")],
                [User(id: 1, name: "A"), User(id: 2, name: "B")],
                [User(id: 1, name: "C"), User(id: 2, name: "B")],
                [User(id: 1, name: "C"), User(id: 2, name: "D")],
                [User(id: 1, name: "C"), User(id: 2, name: "D"), User(id: 3, name: "E")],
                [User(id: 1, name: "F"), User(id: 2, name: "D"), User(id: 3, name: "E")]
            ],
            events
        )

        XCTAssertNotNil(c)
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func testCombineScanIntoUniqueArrayWithMergeable() {
        let upstream = PassthroughSubject<Device, Never>()
        var events: [[Device]] = []
        let expectCompletion = expectation(description: "It should complete")

        // when
        let c = upstream
            .scanIntoUniqueArray()
            .sink(
                receiveCompletion: { _ in expectCompletion.fulfill() },
                receiveValue: { newList in
                    events.append(newList)
                }
            )

        upstream.send(Device(id: 1, name: "A", ip: ["127.0.0.1"]))
        upstream.send(Device(id: 2, name: "B", ip: ["192.168.0.1"]))
        upstream.send(Device(id: 1, name: "C", ip: ["172.0.2.1"]))
        upstream.send(Device(id: 2, name: "D", ip: ["201.202.0.203"]))
        upstream.send(Device(id: 3, name: "E", ip: ["2.0.0.2"]))
        upstream.send(Device(id: 1, name: "F", ip: ["10.5.4.3"]))

        upstream.send(completion: .finished)

        upstream.send(Device(id: 1, name: "F", ip: ["1.1.1.1"]))

        // then

        wait(for: [expectCompletion], timeout: 0.1)

        XCTAssertEqual(
            [
                [
                    Device(id: 1, name: "A", ip: ["127.0.0.1"])
                ],

                [
                    Device(id: 1, name: "A", ip: ["127.0.0.1"]),
                    Device(id: 2, name: "B", ip: ["192.168.0.1"])
                ],

                [
                    Device(id: 1, name: "A", ip: ["127.0.0.1", "172.0.2.1"]),
                    Device(id: 2, name: "B", ip: ["192.168.0.1"])
                ],

                [
                    Device(id: 1, name: "A", ip: ["127.0.0.1", "172.0.2.1"]),
                    Device(id: 2, name: "B", ip: ["192.168.0.1", "201.202.0.203"])
                ],

                [
                    Device(id: 1, name: "A", ip: ["127.0.0.1", "172.0.2.1"]),
                    Device(id: 2, name: "B", ip: ["192.168.0.1", "201.202.0.203"]),
                    Device(id: 3, name: "E", ip: ["2.0.0.2"])
                ],

                [
                    Device(id: 1, name: "A", ip: ["127.0.0.1", "172.0.2.1", "10.5.4.3"]),
                    Device(id: 2, name: "B", ip: ["192.168.0.1", "201.202.0.203"]),
                    Device(id: 3, name: "E", ip: ["2.0.0.2"])
                ]
            ],
            events
        )

        XCTAssertNotNil(c)
    }
}
#endif
