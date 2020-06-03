//
//  DispatchTimeIntervalTests.swift
//  FoundationExtensionsTests
//
//  Created by Luiz Rodrigo Martins Barbosa on 30.04.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

#if !os(watchOS)
import FoundationExtensions
import XCTest

class DispatchTimeIntervalTests: XCTestCase {
    func testFromTimeIntervalRoundToSeconds() {
        // given
        let doubles: [Double] = [1, 2, 3, 4, 5.0000000001]

        // when
        let sut = doubles.map(DispatchTimeInterval.fromTimeInterval)

        // then
        XCTAssertEqual([.seconds(1), .seconds(2), .seconds(3), .seconds(4), .seconds(5)], sut)
        XCTAssertEqual([.milliseconds(1000), .milliseconds(2000), .milliseconds(3000), .milliseconds(4000), .milliseconds(5000)], sut)
        XCTAssertEqual([
            .microseconds(1_000_000),
            .microseconds(2_000_000),
            .microseconds(3_000_000),
            .microseconds(4_000_000),
            .microseconds(5_000_000)
        ], sut)
        XCTAssertEqual([
            .nanoseconds(1_000_000_000),
            .nanoseconds(2_000_000_000),
            .nanoseconds(3_000_000_000),
            .nanoseconds(4_000_000_000),
            .nanoseconds(5_000_000_000)
        ], sut)
    }

    func testFromTimeIntervalRoundToMilliseconds() {
        // given
        let doubles: [Double] = [1e-3, 2e-3, 3e-3, 4e-3, 0.0050000001]

        // when
        let sut = doubles.map(DispatchTimeInterval.fromTimeInterval)

        // then
        XCTAssertEqual([.milliseconds(1), .milliseconds(2), .milliseconds(3), .milliseconds(4), .milliseconds(5)], sut)
        XCTAssertEqual([.microseconds(1000), .microseconds(2000), .microseconds(3000), .microseconds(4000), .microseconds(5000)], sut)
        XCTAssertEqual([
            .nanoseconds(1_000_000),
            .nanoseconds(2_000_000),
            .nanoseconds(3_000_000),
            .nanoseconds(4_000_000),
            .nanoseconds(5_000_000)
        ], sut)
    }

    func testFromTimeIntervalRoundToMicroeconds() {
        // given
        let doubles: [Double] = [1e-6, 2e-6, 3e-6, 4e-6, 0.0000050001]

        // when
        let sut = doubles.map(DispatchTimeInterval.fromTimeInterval)

        // then
        XCTAssertEqual([.microseconds(1), .microseconds(2), .microseconds(3), .microseconds(4), .microseconds(5)], sut)
        XCTAssertEqual([.nanoseconds(1000), .nanoseconds(2000), .nanoseconds(3000), .nanoseconds(4000), .nanoseconds(5000)], sut)
    }

    func testFromTimeIntervalRoundToNanoseconds() {
        // given
        let doubles: [Double] = [1e-9, 2e-9, 3e-9, 4e-9, 5e-9, 6.000000001]

        // when
        let sut = doubles.map(DispatchTimeInterval.fromTimeInterval)

        // then
        XCTAssertEqual([
            .nanoseconds(1),
            .nanoseconds(2),
            .nanoseconds(3),
            .nanoseconds(4),
            .nanoseconds(5),
            .nanoseconds(6000000001)
        ], sut)

        XCTAssertNotEqual(.seconds(6), sut.last!)
    }

    func testToTimeIntervalFromSeconds() {
        // given
        let intervals: [DispatchTimeInterval] = [.seconds(1), .seconds(2), .seconds(3), .seconds(4), .seconds(5)]

        // when
        let sut = intervals.map { $0.toTimeInterval() }

        // then
        XCTAssertEqual([1, 2, 3, 4, 5], sut)
    }

    func testToTimeIntervalFromMilliseconds() {
        // given
        let intervals: [DispatchTimeInterval] =
            [.milliseconds(1), .milliseconds(2), .milliseconds(3), .milliseconds(4), .milliseconds(5)]
                + [.milliseconds(1000), .milliseconds(2000), .milliseconds(3000), .milliseconds(4000), .milliseconds(5000)]

        // when
        let sut = intervals.map { $0.toTimeInterval() }

        // then
        XCTAssertEqual([1e-3, 2e-3, 3e-3, 4e-3, 5e-3, 1, 2, 3, 4, 5], sut)
    }

    func testToTimeIntervalFromMicroseconds() {
        // given
        let intervals: [DispatchTimeInterval] =
            [.microseconds(1), .microseconds(2), .microseconds(3), .microseconds(4), .microseconds(5)]
                + [.microseconds(1000), .microseconds(2000), .microseconds(3000), .microseconds(4000), .microseconds(5000)]
                + [.microseconds(1_000_000), .microseconds(2_000_000), .microseconds(3_000_000), .microseconds(4_000_000), .microseconds(5_000_000)]

        // when
        let sut = intervals.map { $0.toTimeInterval() }

        // then
        XCTAssertEqual([1e-6, 2e-6, 3e-6, 4e-6, 5e-6, 1e-3, 2e-3, 3e-3, 4e-3, 5e-3, 1, 2, 3, 4, 5], sut)
    }

    func testToTimeIntervalFromNanoseconds() {
        // given
        let intervals: [DispatchTimeInterval] =
            [.nanoseconds(1), .nanoseconds(2), .nanoseconds(3), .nanoseconds(4), .nanoseconds(5)]
                + [.nanoseconds(1000), .nanoseconds(2000), .nanoseconds(3000), .nanoseconds(4000), .nanoseconds(5000)]
                + [.nanoseconds(1_000_000), .nanoseconds(2_000_000), .nanoseconds(3_000_000), .nanoseconds(4_000_000), .nanoseconds(5_000_000)]
                + [
                    .nanoseconds(1_000_000_000),
                    .nanoseconds(2_000_000_000),
                    .nanoseconds(3_000_000_000),
                    .nanoseconds(4_000_000_000),
                    .nanoseconds(5_000_000_000)
                ]

        // when
        let sut = intervals.map { $0.toTimeInterval() }

        // then
        XCTAssertEqual([
            1e-9, 2e-9, 3e-9, 4e-9, 5e-9, 1e-6, 2e-6, 3e-6, 4e-6, 5e-6, 1e-3, 2e-3, 3e-3, 4e-3, 5e-3, 1, 2, 3, 4, 5
        ], sut)
    }
}
#endif
