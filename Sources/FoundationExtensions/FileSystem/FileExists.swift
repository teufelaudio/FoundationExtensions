// Copyright © 2021 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(Combine)
import Combine
#endif
import Foundation

public struct FileExists {
    private let _run: (URL) -> Result<Bool, Error>
    
    public init(_ perform: @escaping (URL) -> Result<Bool, Error>) {
        self._run = perform
    }
    
    public func callAsFunction(in path: URL) -> Result<Bool, Error> {
        _run(path)
    }
    
#if canImport(Combine)
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func async(in path: URL, on queue: DispatchQueue) -> Publishers.Promise<Bool, Error> {
        Publishers.Promise<Bool, Error>.perform(in: queue) {
            _run(path)
        }
    }
#endif
}

extension FileExists {
    public static func live(fileManager: FileManagerProtocol = FileManager.default) -> FileExists {
        FileExists { file in
            Result {
                fileManager.fileExists(atPath: file.path)
            }
        }
    }
}
