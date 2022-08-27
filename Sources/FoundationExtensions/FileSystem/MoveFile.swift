// Copyright © 2021 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(Combine)
import Combine
#endif
import Foundation

public struct MoveFile {
    private let _run: (URL, URL, Bool) -> Result<Void, Error>

    public init(_ perform: @escaping (URL, URL, Bool) -> Result<Void, Error>) {
        self._run = perform
    }

    public func callAsFunction(from origin: URL, into destination: URL, replace: Bool = false) -> Result<Void, Error> {
        _run(origin, destination, replace)
    }

#if canImport(Combine)
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func async(from origin: URL, into destination: URL, replace: Bool = false, on queue: DispatchQueue) -> Publishers.Promise<Void, Error> {
        .perform(in: queue) {
            _run(origin, destination, replace)
        }
    }
#endif
}

extension MoveFile {
    public static func live(fileManager: FileManagerProtocol = FileManager.default) -> MoveFile {
        MoveFile { origin, destination, replace in
            Result {
                if replace, fileManager.fileExists(atPath: destination.path) {
                    try fileManager.removeItem(at: destination)
                }

                try fileManager.moveItem(at: origin, to: destination)
            }
        }
    }
}
