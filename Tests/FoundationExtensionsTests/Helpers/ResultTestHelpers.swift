//
//  ResultTestHelpers.swift
//  FoundationExtensionsTests
//
//  Created by Luiz Barbosa on 07.12.18.
//  Copyright © 2018 Lautsprecher Teufel GmbH. All rights reserved.
//

import FoundationExtensions
import XCTest

extension Result {
    func expectedToSucceed() {
        if isFailure {
            XCTFail("Operation was expected to succeed")
        }
    }

    func expectedToFail() {
        if isSuccess {
            XCTFail("Operation was expected to fail")
        }
    }

    func expectedToSuccess(predicate: (Success) -> Bool) {
        analysis(
            ifSuccess: { value in
                if !predicate(value) {
                    XCTFail("Operation has succeeded but with wrong value \(value)")
                }
            },
            ifFailure: { _ in XCTFail("Operation was expected to succeed") })
    }

    func expectedToFail(predicate: (Failure) -> Bool) {
        analysis(
            ifSuccess: { _ in XCTFail("Operation was expected to fail") },
            ifFailure: { error in
                if !predicate(error) {
                    XCTFail("Operation has failed as expected, but with unexpected error \(error)")
                }
            }
        )
    }
}

extension Result where Success: Equatable {
    func expectedToSucceed(with expectedValue: Success) {
        expectedToSuccess { value in
            expectedValue == value
        }
    }
}

extension Result where Failure: Equatable {
    func expectedToFail(with expectedError: Failure) {
        expectedToFail { error in expectedError == error }
    }
}
