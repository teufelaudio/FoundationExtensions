//
//  FileManagerExtensionsTests.swift
//  FoundationExtensionsTests
//
//  Created by Luiz Barbosa on 07.12.18.
//  Copyright © 2018 Lautsprecher Teufel GmbH. All rights reserved.
//

import FoundationExtensions
import XCTest

class FileManagerExtensionsTests: XCTestCase {

    var fileManager: FileManagerProtocolMock!

    override func setUp() {
        super.setUp()
        fileManager = FileManagerProtocolMock()
    }

    func testSpecialFolderSuccess() {
        // given
        let url = URL(fileURLWithPath: "/test/test.png")
        let expectedFolder = FileManager.SearchPathDirectory.cachesDirectory
        fileManager.urlsForInReturnValue = [url, URL(fileURLWithPath: "/test/wrong.png")]

        // when
        let sut = fileManager.specialFolder(expectedFolder)

        // then
        XCTAssertEqual(1, fileManager!.urlsForInCallsCount)
        XCTAssertEqual(expectedFolder, fileManager.urlsForInReceivedArguments?.directory)
        sut.expectedToSucceed(with: url)
    }

    func testSpecialFolderError() {
        // given
        fileManager.urlsForInReturnValue = []
        let expectedFolder = FileManager.SearchPathDirectory.cachesDirectory
        let expectedDomainMask = FileManager.SearchPathDomainMask.userDomainMask

        // when
        let sut = fileManager.specialFolder(expectedFolder)

        // then
        XCTAssertEqual(1, fileManager!.urlsForInCallsCount)
        XCTAssertEqual(expectedFolder, fileManager.urlsForInReceivedArguments?.directory)
        XCTAssertEqual(expectedDomainMask, fileManager.urlsForInReceivedArguments?.domainMask)
        sut.expectedToFail { error in
            if case let .specialFolderNotFound(folder) = error {
                return folder == expectedFolder
            }

            return false
        }
    }

    func testGroupFolderSuccess() {
        // given
        let groupName = "group.com.foo.bar"
        let url = URL(fileURLWithPath: "/test/test.png")
        fileManager.containerURLForSecurityApplicationGroupIdentifierReturnValue = url

        // when
        let sut = fileManager.groupFolder(group: groupName)

        // then
        XCTAssertEqual(1, fileManager!.containerURLForSecurityApplicationGroupIdentifierCallsCount)
        XCTAssertEqual(groupName, fileManager!.containerURLForSecurityApplicationGroupIdentifierReceivedGroupIdentifier)
        sut.expectedToSucceed(with: url)
    }

    func testGroupFolderError() {
        // given
        let groupName = "group.com.foo.bar"
        fileManager.containerURLForSecurityApplicationGroupIdentifierReturnValue = nil

        // when
        let sut = fileManager.groupFolder(group: groupName)

        // then
        XCTAssertEqual(1, fileManager!.containerURLForSecurityApplicationGroupIdentifierCallsCount)
        XCTAssertEqual(groupName, fileManager!.containerURLForSecurityApplicationGroupIdentifierReceivedGroupIdentifier)
        sut.expectedToFail { error in
            if case let .groupFolderNotFound(group) = error {
                return group == groupName
            }

            return false
        }
    }

    func testContentsOfFolderSuccess() {
        // given
        let parentFolder = URL(fileURLWithPath: "/test/foo")
        let expectedFiles = [
            URL(fileURLWithPath: "/test/foo/bar.gif"),
            URL(fileURLWithPath: "/test/foo/bar-klein.gif"),
            URL(fileURLWithPath: "/test/foo/bar-groß.gif")
        ]
        fileManager.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsReturnValue = expectedFiles

        // when
        let sut = fileManager.contents(of: parentFolder)

        // then
        XCTAssertEqual(1, fileManager!.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsCallsCount)
        XCTAssertEqual(parentFolder, fileManager!.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsReceivedArguments!.url)
        XCTAssertNil(fileManager!.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsReceivedArguments!.keys)
        XCTAssertEqual([], fileManager!.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsReceivedArguments!.mask)
        sut.expectedToSucceed(with: expectedFiles)
    }

    func testContentsOfFolderError() {
        // given
        let parentFolder = URL(fileURLWithPath: "/test/foo")
        let methodException = AnyError()
        fileManager.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsThrowableError = methodException

        // when
        let sut = fileManager.contents(of: parentFolder)

        // then
        sut.expectedToFail { error in
            if case let .couldNotRetrieveContentsOfFolder(folder, innerError) = error {
                return folder == parentFolder && (innerError as? AnyError) == methodException
            }

            return false
        }
    }

    func testFolderInParentFolderSuccess() {
        // given
        let parentFolder = URL(fileURLWithPath: "/test/foo")
        let folderName = "bar"
        let expectedPath = "/test/foo/bar"
        let expectedFolder = URL(fileURLWithPath: "/test/foo/bar/")
        fileManager.fileExistsAtPathIsDirectoryClosure = { _, isDir in
            isDir?.initialize(to: true as ObjCBool)
            return true
        }

        // when
        let sut = fileManager.folder(named: folderName, in: parentFolder)

        // then
        XCTAssertEqual(1, fileManager!.fileExistsAtPathIsDirectoryCallsCount)
        XCTAssertEqual(expectedPath, fileManager!.fileExistsAtPathIsDirectoryReceivedArguments?.path)
        sut.expectedToSucceed(with: expectedFolder)
    }

    func testFolderInParentFolderError() {
        // given
        let parentFolder = URL(fileURLWithPath: "/test/foo")
        let folderName = "bar"
        let expectedPath = "/test/foo/bar"
        let expectedFiles = [
            URL(fileURLWithPath: "/test/foo/zbar.gif"),
            URL(fileURLWithPath: "/test/foo/zbar-klein.gif"),
            URL(fileURLWithPath: "/test/foo/zbar-groß.gif")
        ]
        fileManager.fileExistsAtPathIsDirectoryReturnValue = false
        fileManager.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsReturnValue = expectedFiles

        // when
        let sut = fileManager.folder(named: folderName, in: parentFolder)

        // then
        XCTAssertEqual(1, fileManager!.fileExistsAtPathIsDirectoryCallsCount)
        XCTAssertEqual(1, fileManager!.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsCallsCount)
        XCTAssertEqual(parentFolder, fileManager!.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsReceivedArguments!.url)
        XCTAssertNil(fileManager!.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsReceivedArguments!.keys)
        XCTAssertEqual([], fileManager!.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsReceivedArguments!.mask)
        XCTAssertEqual(expectedPath, fileManager!.fileExistsAtPathIsDirectoryReceivedArguments?.path)
        sut.expectedToFail { error in
            if case let .folderNotFound(folder, parent, siblings) = error {
                return folder == folderName && parent == parentFolder && siblings == expectedFiles
            }

            return false
        }
    }

    func testFolderInParentFolderErrorBecauseTheresNoParent() {
        // given
        let parentFolder = URL(fileURLWithPath: "/test/foo")
        let folderName = "bar"
        let expectedPath = "/test/foo/bar"
        fileManager.fileExistsAtPathIsDirectoryReturnValue = false
        fileManager.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsThrowableError = AnyError()

        // when
        let sut = fileManager.folder(named: folderName, in: parentFolder)

        // then
        XCTAssertEqual(1, fileManager!.fileExistsAtPathIsDirectoryCallsCount)
        XCTAssertEqual(expectedPath, fileManager!.fileExistsAtPathIsDirectoryReceivedArguments?.path)
        sut.expectedToFail { error in
            if case let .folderNotFound(folder, parent, siblings) = error {
                return folder == folderName && parent == parentFolder && siblings == []
            }

            return false
        }
    }

    func testFolderInParentFolderErrorBecauseIsFile() {
        // given
        let parentFolder = URL(fileURLWithPath: "/test/foo")
        let folderName = "bar"
        let expectedPath = "/test/foo/bar"
        let expectedFiles = [
            URL(fileURLWithPath: "/test/foo/bar"),
            URL(fileURLWithPath: "/test/foo/zbar-klein.gif"),
            URL(fileURLWithPath: "/test/foo/zbar-groß.gif")
        ]
        fileManager.fileExistsAtPathIsDirectoryClosure = { _, isDir in
            isDir?.initialize(to: false as ObjCBool)
            return true
        }
        fileManager.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsReturnValue = expectedFiles

        // when
        let sut = fileManager.folder(named: folderName, in: parentFolder)

        // then
        XCTAssertEqual(1, fileManager!.fileExistsAtPathIsDirectoryCallsCount)
        XCTAssertEqual(1, fileManager!.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsCallsCount)
        XCTAssertEqual(parentFolder, fileManager!.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsReceivedArguments!.url)
        XCTAssertNil(fileManager!.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsReceivedArguments!.keys)
        XCTAssertEqual([], fileManager!.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsReceivedArguments!.mask)
        XCTAssertEqual(expectedPath, fileManager!.fileExistsAtPathIsDirectoryReceivedArguments?.path)
        sut.expectedToFail { error in
            if case let .folderNotFound(folder, parent, siblings) = error {
                return folder == folderName && parent == parentFolder && siblings == expectedFiles
            }

            return false
        }
    }

    func testFileInParentFolderSuccess() {
        // given
        let parentFolder = URL(fileURLWithPath: "/test/foo")
        let fileName = "bar.txt"
        let expectedPath = "/test/foo/bar.txt"
        let expectedFile = URL(fileURLWithPath: "/test/foo/bar.txt")
        fileManager.fileExistsAtPathReturnValue = true

        // when
        let sut = fileManager.file(named: fileName, in: parentFolder)

        // then
        XCTAssertEqual(1, fileManager!.fileExistsAtPathCallsCount)
        XCTAssertEqual(expectedPath, fileManager!.fileExistsAtPathReceivedPath)
        sut.expectedToSucceed(with: expectedFile)
    }

    func testFileInParentFolderError() {
        // given
        let parentFolder = URL(fileURLWithPath: "/test/foo")
        let fileName = "bar.txt"
        let expectedPath = "/test/foo/bar.txt"
        let expectedFiles = [
            URL(fileURLWithPath: "/test/foo/zbar.gif"),
            URL(fileURLWithPath: "/test/foo/zbar-klein.gif"),
            URL(fileURLWithPath: "/test/foo/zbar-groß.gif")
        ]
        fileManager.fileExistsAtPathReturnValue = false
        fileManager.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsReturnValue = expectedFiles

        // when
        let sut = fileManager.file(named: fileName, in: parentFolder)

        // then
        XCTAssertEqual(1, fileManager!.fileExistsAtPathCallsCount)
        XCTAssertEqual(1, fileManager!.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsCallsCount)
        XCTAssertEqual(parentFolder, fileManager!.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsReceivedArguments!.url)
        XCTAssertNil(fileManager!.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsReceivedArguments!.keys)
        XCTAssertEqual([], fileManager!.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsReceivedArguments!.mask)
        XCTAssertEqual(expectedPath, fileManager!.fileExistsAtPathReceivedPath)
        sut.expectedToFail { error in
            if case let .fileNotFound(file, parent, siblings) = error {
                return file == fileName && parent == parentFolder && siblings == expectedFiles
            }

            return false
        }
    }

    func testFileInParentFolderErrorBecauseTheresNoParent() {
        // given
        let parentFolder = URL(fileURLWithPath: "/test/foo")
        let fileName = "bar.txt"
        let expectedPath = "/test/foo/bar.txt"
        fileManager.fileExistsAtPathReturnValue = false
        fileManager.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsThrowableError = AnyError()

        // when
        let sut = fileManager.file(named: fileName, in: parentFolder)

        // then
        XCTAssertEqual(1, fileManager!.fileExistsAtPathCallsCount)
        XCTAssertEqual(expectedPath, fileManager!.fileExistsAtPathReceivedPath)
        sut.expectedToFail { error in
            if case let .fileNotFound(file, parent, siblings) = error {
                return file == fileName && parent == parentFolder && siblings == []
            }

            return false
        }
    }

    func testCopyFileSuccess() {
        // given
        let source = URL(fileURLWithPath: "/test/foo/foozz123.gif")
        let destination = URL(fileURLWithPath: "/test/bar/barzz321.gif")

        // when
        let sut = fileManager.copy(file: source, to: destination)

        // then
        XCTAssertEqual(1, fileManager!.copyItemAtToCallsCount)
        XCTAssertEqual(source, fileManager!.copyItemAtToReceivedArguments!.srcURL)
        XCTAssertEqual(destination, fileManager!.copyItemAtToReceivedArguments!.dstURL)
        sut.expectedToSucceed()
    }

    func testCopyFileError() {
        // given
        let source = URL(fileURLWithPath: "/test/foo/foozz123.gif")
        let destination = URL(fileURLWithPath: "/test/bar/barzz321.gif")
        let copyError = AnyError()
        fileManager.copyItemAtToThrowableError = copyError

        // when
        let sut = fileManager.copy(file: source, to: destination)

        // then
        sut.expectedToFail { error in
            if case let .fileCopyHasFailed(srcURL, dstURL, innerError) = error {
                return srcURL == source && dstURL == destination && (innerError as? AnyError) == copyError
            }

            return false
        }
    }

    func testEnsureFolderExistsSuccess() {
        // given
        let newFolder = URL(fileURLWithPath: "/test/foo/bar/")
        fileManager.fileExistsAtPathIsDirectoryReturnValue = true

        // when
        let sut = fileManager.ensureFolderExists(newFolder, createIfNeeded: true)

        // then
        XCTAssertEqual(1, fileManager!.fileExistsAtPathIsDirectoryCallsCount)
        XCTAssertEqual(0, fileManager!.createDirectoryAtWithIntermediateDirectoriesAttributesCallsCount)
        sut.expectedToSucceed()
    }

    func testEnsureFolderExistsSuccessBecauseCreates() {
        // given
        let newFolder = URL(fileURLWithPath: "/test/foo/bar/")
        fileManager.fileExistsAtPathIsDirectoryReturnValue = false

        // when
        let sut = fileManager.ensureFolderExists(newFolder, createIfNeeded: true)

        // then
        XCTAssertEqual(1, fileManager!.fileExistsAtPathIsDirectoryCallsCount)
        XCTAssertEqual(1, fileManager!.createDirectoryAtWithIntermediateDirectoriesAttributesCallsCount)
        sut.expectedToSucceed()
    }

    func testEnsureFolderExistsErrorBecauseWeDontWantToCreate() {
        // given
        let folderName = "bar"
        let parentFolder = URL(fileURLWithPath: "/test/foo/", isDirectory: true)
        let newFolder = URL(fileURLWithPath: "/test/foo/bar/", isDirectory: true)
        fileManager.fileExistsAtPathIsDirectoryReturnValue = false
        let expectedFiles = [
            URL(fileURLWithPath: "/test/foo/zbar.gif"),
            URL(fileURLWithPath: "/test/foo/zbar-klein.gif"),
            URL(fileURLWithPath: "/test/foo/zbar-groß.gif")
        ]
        fileManager.contentsOfDirectoryAtIncludingPropertiesForKeysOptionsReturnValue = expectedFiles

        // when
        let sut = fileManager.ensureFolderExists(newFolder, createIfNeeded: false)

        // then
        XCTAssertEqual(1, fileManager!.fileExistsAtPathIsDirectoryCallsCount)
        XCTAssertEqual(0, fileManager!.createDirectoryAtWithIntermediateDirectoriesAttributesCallsCount)
        sut.expectedToFail { error in
            if case let .folderNotFound(folder, parent, siblings) = error {
                return folder == folderName && parent == parentFolder && siblings == expectedFiles
            }

            return false
        }
    }

    func testEnsureFolderExistsErrorOnCreating() {
        // given
        let newFolder = URL(fileURLWithPath: "/test/foo/bar/")
        fileManager.fileExistsAtPathIsDirectoryReturnValue = false
        let creationError = AnyError()
        fileManager.createDirectoryAtWithIntermediateDirectoriesAttributesThrowableError = creationError

        // when
        let sut = fileManager.ensureFolderExists(newFolder, createIfNeeded: true)

        // then
        XCTAssertEqual(1, fileManager!.fileExistsAtPathIsDirectoryCallsCount)
        sut.expectedToFail { error in
            if case let .createFolderHasFailed(folder, innerError) = error {
                return folder == newFolder && (innerError as? AnyError) == creationError
            }

            return false
        }
    }
}
