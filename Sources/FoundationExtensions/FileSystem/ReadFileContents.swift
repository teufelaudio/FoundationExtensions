// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Combine
import Foundation

public struct ReadFileContents: Sendable {
    private let _run: @Sendable (URL) -> Result<Data, Error>

    public init(_ perform: @escaping @Sendable (URL) -> Result<Data, Error>) {
        self._run = perform
    }

    public func callAsFunction(from origin: URL) -> Result<Data, Error> {
        _run(origin)
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func async(from origin: URL, on queue: DispatchQueue) -> Publishers.Promise<Data, Error> {
        Publishers.Promise { promise in
            promise(_run(origin))
            return AnyCancellable {}
        }
        .subscribe(on: queue)
    }
}

extension ReadFileContents {
    public static var live: Self {
        .init { origin in
            Result {
                try Data(contentsOf: origin, options: .alwaysMapped)
            }
        }
    }
}
