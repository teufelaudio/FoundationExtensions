// Copyright © 2021 Lautsprecher Teufel GmbH. All rights reserved.

import Combine
import Foundation

public struct ReadFileContents {
    private let _run: (URL) -> Result<Data, Error>

    public init(_ perform: @escaping (URL) -> Result<Data, Error>) {
        self._run = perform
    }

    public func callAsFunction(from origin: URL) -> Result<Data, Error> {
        _run(origin)
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func async(from origin: URL, on queue: DispatchQueue) -> Publishers.Promise<Data, Error> {
        .perform(in: queue) {
            _run(origin)
        }
    }
}

extension ReadFileContents {
    public static let live = ReadFileContents { origin in
        Result {
            try Data(contentsOf: origin, options: .alwaysMapped)
        }
    }
}
