// Copyright © 2024 Lautsprecher Teufel GmbH. All rights reserved.

import FoundationExtensions
import XCTest

final class TimeIntervalTests: XCTestCase {
    func testDurationToTimeIntervalZero() {
        let duration = Duration.safe(secondsComponent: 0, attosecondsComponent: 0)
        let timeInterval = TimeInterval(duration)
        XCTAssertEqual(timeInterval, 0.0)
    }

    func testDurationToTimeIntervalPositiveSeconds() {
        let duration = Duration.safe(secondsComponent: 5, attosecondsComponent: 0)
        let timeInterval = TimeInterval(duration)
        XCTAssertEqual(timeInterval, 5.0)
    }

    func testDurationToTimeIntervalNegativeSeconds() {
        let duration = Duration.safe(secondsComponent: -5, attosecondsComponent: 0)
        let timeInterval = TimeInterval(duration)
        XCTAssertEqual(timeInterval, -5.0)
    }

    func testDurationToTimeIntervalLargePositiveAttoseconds() {
        let duration = Duration.safe(secondsComponent: 0, attosecondsComponent: 1_000_000_000_000_000_000)
        let timeInterval = TimeInterval(duration)
        XCTAssertEqual(timeInterval, 1.0)
    }

    func testDurationToTimeIntervalLargeNegativeAttoseconds() {
        let duration = Duration.safe(secondsComponent: 0, attosecondsComponent: -1_000_000_000_000_000_000)
        let timeInterval = TimeInterval(duration)
        XCTAssertEqual(timeInterval, -1.0)
    }

    func testDurationToTimeIntervalClamping() {
        let duration = Duration.safe(secondsComponent: Int64.max, attosecondsComponent: Int64(1e18)-1)
        let timeInterval = TimeInterval(duration)
        XCTAssertEqual(timeInterval, TimeInterval(Int64.max) + TimeInterval(Int64(1e18) - 1) / 1e18)

        let negativeDuration = Duration.safe(secondsComponent: Int64.min, attosecondsComponent: -Int64(1e18)+1)
        let negativeTimeInterval = TimeInterval(negativeDuration)
        XCTAssertEqual(negativeTimeInterval, TimeInterval(Int64.min) + TimeInterval(-Int64(1e18) + 1) / 1e18)
    }

    func testDurationToTimeIntervalMixed() {
        let duration = Duration.safe(secondsComponent: Int64.max, attosecondsComponent: 9_000_000_000_000_000_000)
        let timeInterval = TimeInterval(duration)
        XCTAssertEqual(timeInterval, TimeInterval(Int64.max))
    }

    func testDurationToTimeIntervalSmallPositiveAttoseconds() {
        let duration = Duration.safe(secondsComponent: 0, attosecondsComponent: 1)
        let timeInterval = TimeInterval(duration)
        XCTAssertEqual(timeInterval, 1e-18)
    }

    func testDurationToTimeIntervalSmallNegativeAttoseconds() {
        let duration = Duration.safe(secondsComponent: 0, attosecondsComponent: -1)
        let timeInterval = TimeInterval(duration)
        XCTAssertEqual(timeInterval, -1e-18)
    }

    func testDurationToTimeIntervalLargePositiveSeconds() {
        let duration = Duration.safe(secondsComponent: Int64.max - 1, attosecondsComponent: 999_999_999_999_999_999)
        let timeInterval = TimeInterval(duration)
        let expected = TimeInterval(Int64.max - 1) + 0.999_999_999_999_999_999
        XCTAssertEqual(timeInterval, expected)
    }

    func testDurationToTimeIntervalLargeNegativeSeconds() {
        let duration = Duration.safe(secondsComponent: Int64.min + 1, attosecondsComponent: -999_999_999_999_999_999)
        let timeInterval = TimeInterval(duration)
        let expected = TimeInterval(Int64.min + 1) - 0.999_999_999_999_999_999
        XCTAssertEqual(timeInterval, expected)
    }

    func testDurationToTimeIntervalMaxOverflowAttoseconds() {
        let duration = Duration.safe(secondsComponent: Int64.max, attosecondsComponent: 1)
        let timeInterval = TimeInterval(duration)
        XCTAssertEqual(timeInterval, TimeInterval(Int64.max))
    }

    func testDurationToTimeIntervalMinOverflowAttoseconds() {
        let duration = Duration.safe(secondsComponent: Int64.min, attosecondsComponent: -1)
        let timeInterval = TimeInterval(duration)
        XCTAssertEqual(timeInterval, TimeInterval(Int64.min))
    }

    func testDurationToTimeIntervalExceedingPositiveAttoseconds() {
        let duration = Duration.safe(secondsComponent: Int64.max, attosecondsComponent: 9_000_000_000_000_000_001)
        let timeInterval = TimeInterval(duration)
        XCTAssertEqual(timeInterval, TimeInterval(Int64.max))
    }

    func testDurationToTimeIntervalExceedingNegativeAttoseconds() {
        let duration = Duration.safe(secondsComponent: Int64.min, attosecondsComponent: -1_000_000_000_000_000_001)
        let timeInterval = TimeInterval(duration)
        XCTAssertEqual(timeInterval, TimeInterval(Int64.min))
    }

    func testDurationToTimeIntervalSubAttosecondPrecision() {
        let duration = Duration.safe(secondsComponent: 0, attosecondsComponent: 1)
        let timeInterval = TimeInterval(duration)
        XCTAssertEqual(timeInterval, 1e-18)
    }

    func testDurationToTimeIntervalNegativeSecondsPositiveAttoseconds() {
        let duration = Duration.safe(secondsComponent: -1, attosecondsComponent: 500_000_000_000_000_000)
        let timeInterval = TimeInterval(duration)
        XCTAssertEqual(timeInterval, -0.5)
    }

    func testDurationToTimeIntervalPositiveSecondsNegativeAttoseconds() {
        let duration = Duration.safe(secondsComponent: 1, attosecondsComponent: -500_000_000_000_000_000)
        let timeInterval = TimeInterval(duration)
        XCTAssertEqual(timeInterval, 0.5)
    }
}

extension TimeIntervalTests {
    func testMinutesToSeconds() {
        // Given
        let minutes: Int32 = 1

        // When
        let result = Duration.minutes(minutes)

        // Then
        XCTAssertEqual(result, .seconds(60))
    }

    func testMinutesToSeconds_MultipleMinutes() {
        // Given
        let minutes: Int32 = 10

        // When
        let result = Duration.minutes(minutes)

        // Then
        XCTAssertEqual(result, .seconds(600))
    }

    func testMinutesToSeconds_ZeroMinutes() {
        // Given
        let minutes: Int32 = 0

        // When
        let result = Duration.minutes(minutes)

        // Then
        XCTAssertEqual(result, .seconds(0))
    }

    func testMinutesToSeconds_NegativeMinutes() {
        // Given
        let minutes: Int32 = -5

        // When
        let result = Duration.minutes(minutes)

        // Then
        XCTAssertEqual(result, .seconds(-300))
    }

    func testMinutesToSeconds_MaxMinutes() {
        // Given
        let minutes: Int32 = Int32.max

        // When
        let result = Duration.minutes(minutes)

        // Then
        XCTAssertEqual(result, .seconds(Int64(Int32.max) * 60))
    }

    func testMinutesToSeconds_MinMinutes() {
        // Given
        let minutes: Int32 = Int32.min

        // When
        let result = Duration.minutes(minutes)

        // Then
        XCTAssertEqual(result, .seconds(Int64(Int32.min) * 60))
    }

    // MARK: - Hours

    func testHoursToSeconds() {
        // Given
        let hours: Int32 = 1

        // When
        let result = Duration.hours(hours)

        // Then
        XCTAssertEqual(result, .seconds(3600))
    }

    func testHoursToSeconds_MultipleHours() {
        // Given
        let hours: Int32 = 5

        // When
        let result = Duration.hours(hours)

        // Then
        XCTAssertEqual(result, .seconds(18000))
    }

    func testHoursToSeconds_ZeroHours() {
        // Given
        let hours: Int32 = 0

        // When
        let result = Duration.hours(hours)

        // Then
        XCTAssertEqual(result, .seconds(0))
    }

    func testHoursToSeconds_NegativeHours() {
        // Given
        let hours: Int32 = -2

        // When
        let result = Duration.hours(hours)

        // Then
        XCTAssertEqual(result, .seconds(-7200))
    }

    func testHoursToSeconds_MaxHours() {
        // Given
        let hours: Int32 = Int32.max

        // When
        let result = Duration.hours(hours)

        // Then
        XCTAssertEqual(result, .seconds(Int64(Int32.max) * 3600))
    }

    func testHoursToSeconds_MinHours() {
        // Given
        let hours: Int32 = Int32.min

        // When
        let result = Duration.hours(hours)

        // Then
        XCTAssertEqual(result, .seconds(Int64(Int32.min) * 3600))
    }
}

