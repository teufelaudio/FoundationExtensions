//
//  FileManager+Extensions.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 07.12.18.
//  Copyright © 2018 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

// sourcery: AutoMockable
public protocol FileManagerProtocol {
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL]
    #if !os(Linux)
    func containerURL(forSecurityApplicationGroupIdentifier groupIdentifier: String) -> URL?
    #endif
    func contentsOfDirectory(at url: URL,
                             includingPropertiesForKeys keys: [URLResourceKey]?,
                             options mask: FileManager.DirectoryEnumerationOptions) throws -> [URL]
    func fileExists(atPath path: String) -> Bool
    func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool
    func copyItem(at srcURL: URL, to dstURL: URL) throws
    func moveItem(at srcURL: URL, to dstURL: URL) throws
    func linkItem(at srcURL: URL, to dstURL: URL) throws
    func removeItem(at URL: URL) throws
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey: Any]?) throws
}

public enum FileManagerError: Error {
    case couldNotRetrieveContentsOfFolder(parentFolder: URL, error: Error)
    case fileNotFound(fileName: String, parent: URL, childrenFoundOnParent: [URL])
    case specialFolderNotFound(FileManager.SearchPathDirectory)
    case groupFolderNotFound(groupName: String)
    case folderNotFound(folderName: String, parent: URL?, childrenFoundOnParent: [URL])
    case fileCopyHasFailed(sourceFile: URL, destinationFile: URL, error: Error)
    case createFolderHasFailed(folder: URL, error: Error)
}

extension FileManagerProtocol {
    public func specialFolder(_ folder: FileManager.SearchPathDirectory) -> Result<URL, FileManagerError> {
        return urls(for: folder, in: .userDomainMask)
            .first
            .toResult(orError: FileManagerError.specialFolderNotFound(folder))
    }

    #if !os(Linux)
    public func groupFolder(group: String) -> Result<URL, FileManagerError> {
        return containerURL(forSecurityApplicationGroupIdentifier: group)
            .toResult(orError: FileManagerError.groupFolderNotFound(groupName: group))
    }
    #endif

    public func contents(of parentFolder: URL) -> Result<[URL], FileManagerError> {
        return Result(catching: { try contentsOfDirectory(at: parentFolder, includingPropertiesForKeys: nil, options: []) })
            .biMap(identity, errorTransform: { error in FileManagerError.couldNotRetrieveContentsOfFolder(parentFolder: parentFolder, error: error) })
    }

    public func folder(named folderName: String, in parentFolder: URL) -> Result<URL, FileManagerError> {
        let folderUrl = parentFolder.appendingPathComponent(folderName, isDirectory: true)

        var isDirectory: ObjCBool = true
        if fileExists(atPath: folderUrl.path, isDirectory: &isDirectory), isDirectory.boolValue {
            return .success(folderUrl)
        } else {
            return .failure(.folderNotFound(folderName: folderName,
                                            parent: parentFolder,
                                            childrenFoundOnParent: contents(of: parentFolder).value ?? []))
        }
    }

    public func file(named fileName: String, in parentFolder: URL) -> Result<URL, FileManagerError> {
        let fileUrl = parentFolder.appendingPathComponent(fileName, isDirectory: false)

        if fileExists(atPath: fileUrl.path) {
            return .success(fileUrl)
        } else {
            return .failure(.fileNotFound(fileName: fileName, parent: parentFolder, childrenFoundOnParent: contents(of: parentFolder).value ?? []))
        }
    }

    public func copy(file source: URL, to destination: URL) -> Result<Void, FileManagerError> {
        return Result(catching: {
            try copyItem(at: source, to: destination)
        }).biMap(identity, errorTransform: {
            FileManagerError.fileCopyHasFailed(sourceFile: source, destinationFile: destination, error: $0)
        })
    }

    public func ensureFolderExists(_ folder: URL, createIfNeeded: Bool = false) -> Result<URL, FileManagerError> {
        var isDirectory: ObjCBool = true
        if fileExists(atPath: folder.path, isDirectory: &isDirectory), isDirectory.boolValue {
            return .success(folder)
        }

        if !createIfNeeded {
            return .failure(FileManagerError.folderNotFound(folderName: folder.lastPathComponent,
                                                          parent: folder.deletingLastPathComponent(),
                                                          childrenFoundOnParent: contents(of: folder.deletingLastPathComponent()).value ?? []))
        }

        return Result(catching: {
            try createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
            return folder
        }).biMap(identity, errorTransform: {
            FileManagerError.createFolderHasFailed(folder: folder, error: $0)
        })
    }
}

extension FileManager: FileManagerProtocol { }
