// Copyright © 2021 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(Combine)
import Combine
#endif

import Foundation

public struct ReadFileContents {
    private let _run: (URL) -> Result<Data, Error>

    public init(_ perform: @escaping (URL) -> Result<Data, Error>) {
        self._run = perform
    }

    public func callAsFunction(from origin: URL) -> Result<Data, Error> {
        _run(origin)
    }

#if canImport(Combine)
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func async(from origin: URL, on queue: DispatchQueue) -> Publishers.Promise<Data, Error> {
        .perform(in: queue) {
            _run(origin)
        }
    }
#endif
}

extension ReadFileContents {
    public static let live = ReadFileContents { origin in
        Result {
            try Data(contentsOf: origin, options: .alwaysMapped)
        }
    }
}
