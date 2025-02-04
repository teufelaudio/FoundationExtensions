// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Combine
import Foundation

public struct MoveFile: Sendable {
    private let _run: @Sendable (URL, URL, Bool) -> Result<Void, Error>

    public init(_ perform: @escaping @Sendable (URL, URL, Bool) -> Result<Void, Error>) {
        self._run = perform
    }

    public func callAsFunction(from origin: URL, into destination: URL, replace: Bool = false) -> Result<Void, Error> {
        _run(origin, destination, replace)
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func async(from origin: URL, into destination: URL, replace: Bool = false, on queue: DispatchQueue) -> Publishers.Promise<Void, Error> {
        Publishers.Promise { promise in
            promise(_run(origin, destination, replace))
            return AnyCancellable {}
        }
        .subscribe(on: queue)
    }
}

extension MoveFile {
    public static func live(fileManager: any FileManagerProtocol & Sendable) -> MoveFile {
        MoveFile { origin, destination, replace in
            Result {
                if replace, fileManager.fileExists(atPath: destination.path) {
                    try fileManager.removeItem(at: destination)
                }

                try fileManager.moveItem(at: origin, to: destination)
            }
        }
    }

    public static func live() -> Self {
        MoveFile { origin, destination, replace in
            Result {
                if replace, FileManager.default.fileExists(atPath: destination.path) {
                    try FileManager.default.removeItem(at: destination)
                }

                try FileManager.default.moveItem(at: origin, to: destination)
            }
        }
    }
}
