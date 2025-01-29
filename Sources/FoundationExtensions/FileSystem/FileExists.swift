// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Combine
import Foundation

public struct FileExists: Sendable {
    private let _run: @Sendable (URL) -> Result<Bool, Error>

    public init(_ perform: @escaping @Sendable (URL) -> Result<Bool, Error>) {
        self._run = perform
    }

    public func callAsFunction(in path: URL) -> Result<Bool, Error> {
        _run(path)
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func async(in path: URL, on queue: DispatchQueue) -> Publishers.Promise<Bool, Error> {
        Publishers.Promise<Bool, Error> { promise in
            promise(_run(path))
            return AnyCancellable {}
        }
        .subscribe(on: queue)
    }
}

extension FileExists {
    public static func live(fileManager: any FileManagerProtocol & Sendable ) -> FileExists {
        FileExists { file in
            Result {
                fileManager.fileExists(atPath: file.path)
            }
        }
    }

    public static func live() -> FileExists {
        FileExists { file in
            Result {
                FileManager.default.fileExists(atPath: file.path)
            }
        }
    }
}
