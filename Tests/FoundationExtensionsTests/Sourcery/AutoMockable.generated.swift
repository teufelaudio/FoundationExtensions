// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable all

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import Foundation
import Combine
@testable import FoundationExtensions

class FileManagerProtocolMock: FileManagerProtocol {
    //MARK: - urls

    var urlsForInCallsCount = 0
    var urlsForInCalled: Bool {
        return urlsForInCallsCount > 0
    }
    var urlsForInReceivedArguments: (directory: FileManager.SearchPathDirectory, domainMask: FileManager.SearchPathDomainMask)?
    var urlsForInReturnValue: [URL]!
    var urlsForInClosure: ((FileManager.SearchPathDirectory, FileManager.SearchPathDomainMask) -> [URL])?

    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        urlsForInCallsCount += 1
        urlsForInReceivedArguments = (directory: directory, domainMask: domainMask)
        return urlsForInClosure.map({ $0(directory, domainMask) }) ?? urlsForInReturnValue
    }

    //MARK: - containerURL

    var containerURLForSecurityApplicationGroupIdentifierCallsCount = 0
    var containerURLForSecurityApplicationGroupIdentifierCalled: Bool {
        return containerURLForSecurityApplicationGroupIdentifierCallsCount > 0
    }
    var containerURLForSecurityApplicationGroupIdentifierReceivedGroupIdentifier: String?
    var containerURLForSecurityApplicationGroupIdentifierReturnValue: URL?
    var containerURLForSecurityApplicationGroupIdentifierClosure: ((String) -> URL?)?

    func containerURL(forSecurityApplicationGroupIdentifier groupIdentifier: String) -> URL? {
        containerURLForSecurityApplicationGroupIdentifierCallsCount += 1
        containerURLForSecurityApplicationGroupIdentifierReceivedGroupIdentifier = groupIdentifier
        return containerURLForSecurityApplicationGroupIdentifierClosure.map({ $0(groupIdentifier) }) ?? containerURLForSecurityApplicationGroupIdentifierReturnValue
    }

    //MARK: - contentsOfDirectory

    var contentsOfDirectoryAtIncludingPropertiesForKeysOptionsThrowableError: Error?
    var contentsOfDirectoryAtIncludingPropertiesForKeysOptionsCallsCount = 0
    var contentsOfDirectoryAtIncludingPropertiesForKeysOptionsCalled: Bool {
        return contentsOfDirectoryAtIncludingPropertiesForKeysOptionsCallsCount > 0
    }
    var contentsOfDirectoryAtIncludingPropertiesForKeysOptionsReceivedArguments: (url: URL, keys: [URLResourceKey]?, mask: FileManager.DirectoryEnumerationOptions)?
    var contentsOfDirectoryAtIncludingPropertiesForKeysOptionsReturnValue: [URL]!
    var contentsOfDirectoryAtIncludingPropertiesForKeysOptionsClosure: ((URL, [URLResourceKey]?, FileManager.DirectoryEnumerationOptions) throws -> [URL])?

    func contentsOfDirectory(at url: URL,                             includingPropertiesForKeys keys: [URLResourceKey]?,                             options mask: FileManager.DirectoryEnumerationOptions) throws -> [URL] {
        if let error = contentsOfDirectoryAtIncludingPropertiesForKeysOptionsThrowableError {
            throw error
        }
        contentsOfDirectoryAtIncludingPropertiesForKeysOptionsCallsCount += 1
        contentsOfDirectoryAtIncludingPropertiesForKeysOptionsReceivedArguments = (url: url, keys: keys, mask: mask)
        return try contentsOfDirectoryAtIncludingPropertiesForKeysOptionsClosure.map({ try $0(url, keys, mask) }) ?? contentsOfDirectoryAtIncludingPropertiesForKeysOptionsReturnValue
    }

    //MARK: - fileExists

    var fileExistsAtPathCallsCount = 0
    var fileExistsAtPathCalled: Bool {
        return fileExistsAtPathCallsCount > 0
    }
    var fileExistsAtPathReceivedPath: String?
    var fileExistsAtPathReturnValue: Bool!
    var fileExistsAtPathClosure: ((String) -> Bool)?

    func fileExists(atPath path: String) -> Bool {
        fileExistsAtPathCallsCount += 1
        fileExistsAtPathReceivedPath = path
        return fileExistsAtPathClosure.map({ $0(path) }) ?? fileExistsAtPathReturnValue
    }

    //MARK: - fileExists

    var fileExistsAtPathIsDirectoryCallsCount = 0
    var fileExistsAtPathIsDirectoryCalled: Bool {
        return fileExistsAtPathIsDirectoryCallsCount > 0
    }
    var fileExistsAtPathIsDirectoryReceivedArguments: (path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?)?
    var fileExistsAtPathIsDirectoryReturnValue: Bool!
    var fileExistsAtPathIsDirectoryClosure: ((String, UnsafeMutablePointer<ObjCBool>?) -> Bool)?

    func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
        fileExistsAtPathIsDirectoryCallsCount += 1
        fileExistsAtPathIsDirectoryReceivedArguments = (path: path, isDirectory: isDirectory)
        return fileExistsAtPathIsDirectoryClosure.map({ $0(path, isDirectory) }) ?? fileExistsAtPathIsDirectoryReturnValue
    }

    //MARK: - copyItem

    var copyItemAtToThrowableError: Error?
    var copyItemAtToCallsCount = 0
    var copyItemAtToCalled: Bool {
        return copyItemAtToCallsCount > 0
    }
    var copyItemAtToReceivedArguments: (srcURL: URL, dstURL: URL)?
    var copyItemAtToClosure: ((URL, URL) throws -> Void)?

    func copyItem(at srcURL: URL, to dstURL: URL) throws {
        if let error = copyItemAtToThrowableError {
            throw error
        }
        copyItemAtToCallsCount += 1
        copyItemAtToReceivedArguments = (srcURL: srcURL, dstURL: dstURL)
        try copyItemAtToClosure?(srcURL, dstURL)
    }

    //MARK: - moveItem

    var moveItemAtToThrowableError: Error?
    var moveItemAtToCallsCount = 0
    var moveItemAtToCalled: Bool {
        return moveItemAtToCallsCount > 0
    }
    var moveItemAtToReceivedArguments: (srcURL: URL, dstURL: URL)?
    var moveItemAtToClosure: ((URL, URL) throws -> Void)?

    func moveItem(at srcURL: URL, to dstURL: URL) throws {
        if let error = moveItemAtToThrowableError {
            throw error
        }
        moveItemAtToCallsCount += 1
        moveItemAtToReceivedArguments = (srcURL: srcURL, dstURL: dstURL)
        try moveItemAtToClosure?(srcURL, dstURL)
    }

    //MARK: - linkItem

    var linkItemAtToThrowableError: Error?
    var linkItemAtToCallsCount = 0
    var linkItemAtToCalled: Bool {
        return linkItemAtToCallsCount > 0
    }
    var linkItemAtToReceivedArguments: (srcURL: URL, dstURL: URL)?
    var linkItemAtToClosure: ((URL, URL) throws -> Void)?

    func linkItem(at srcURL: URL, to dstURL: URL) throws {
        if let error = linkItemAtToThrowableError {
            throw error
        }
        linkItemAtToCallsCount += 1
        linkItemAtToReceivedArguments = (srcURL: srcURL, dstURL: dstURL)
        try linkItemAtToClosure?(srcURL, dstURL)
    }

    //MARK: - removeItem

    var removeItemAtThrowableError: Error?
    var removeItemAtCallsCount = 0
    var removeItemAtCalled: Bool {
        return removeItemAtCallsCount > 0
    }
    var removeItemAtReceivedURL: URL?
    var removeItemAtClosure: ((URL) throws -> Void)?

    func removeItem(at URL: URL) throws {
        if let error = removeItemAtThrowableError {
            throw error
        }
        removeItemAtCallsCount += 1
        removeItemAtReceivedURL = URL
        try removeItemAtClosure?(URL)
    }

    //MARK: - createDirectory

    var createDirectoryAtWithIntermediateDirectoriesAttributesThrowableError: Error?
    var createDirectoryAtWithIntermediateDirectoriesAttributesCallsCount = 0
    var createDirectoryAtWithIntermediateDirectoriesAttributesCalled: Bool {
        return createDirectoryAtWithIntermediateDirectoriesAttributesCallsCount > 0
    }
    var createDirectoryAtWithIntermediateDirectoriesAttributesReceivedArguments: (url: URL, createIntermediates: Bool, attributes: [FileAttributeKey: Any]?)?
    var createDirectoryAtWithIntermediateDirectoriesAttributesClosure: ((URL, Bool, [FileAttributeKey: Any]?) throws -> Void)?

    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey: Any]?) throws {
        if let error = createDirectoryAtWithIntermediateDirectoriesAttributesThrowableError {
            throw error
        }
        createDirectoryAtWithIntermediateDirectoriesAttributesCallsCount += 1
        createDirectoryAtWithIntermediateDirectoriesAttributesReceivedArguments = (url: url, createIntermediates: createIntermediates, attributes: attributes)
        try createDirectoryAtWithIntermediateDirectoriesAttributesClosure?(url, createIntermediates, attributes)
    }

}
class TimerProtocolMock: TimerProtocol {
    var fireDate: Date {
        get { return underlyingFireDate }
        set(value) { underlyingFireDate = value }
    }
    var underlyingFireDate: Date!
    var timeInterval: TimeInterval {
        get { return underlyingTimeInterval }
        set(value) { underlyingTimeInterval = value }
    }
    var underlyingTimeInterval: TimeInterval!
    var tolerance: TimeInterval {
        get { return underlyingTolerance }
        set(value) { underlyingTolerance = value }
    }
    var underlyingTolerance: TimeInterval!
    var isValid: Bool {
        get { return underlyingIsValid }
        set(value) { underlyingIsValid = value }
    }
    var underlyingIsValid: Bool!
    var userInfo: Any?
    //MARK: - fire

    var fireCallsCount = 0
    var fireCalled: Bool {
        return fireCallsCount > 0
    }
    var fireClosure: (() -> Void)?

    func fire() {
        fireCallsCount += 1
        fireClosure?()
    }

    //MARK: - invalidate

    var invalidateCallsCount = 0
    var invalidateCalled: Bool {
        return invalidateCallsCount > 0
    }
    var invalidateClosure: (() -> Void)?

    func invalidate() {
        invalidateCallsCount += 1
        invalidateClosure?()
    }

}
