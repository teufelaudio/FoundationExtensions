import Combine
import Foundation

extension Publisher {
    public func retry() -> AnyPublisher<Output, Never> {
        Publishers
            .Retry(upstream: self, retries: nil)
            .assertNoFailure() // It theoretically throws fatalError on Publisher Failure.
                               // But Retry forever will never allow errors to pass anyway.
            .eraseToAnyPublisher()
    }
}

extension Publishers.Promise {
    public func retry() -> Publishers.Promise<Output, Never> {
        Publishers
            .Retry(upstream: self, retries: nil)
            .assertNoFailure()       // It theoretically throws fatalError on Publisher Failure.
                                     // But Retry forever will never allow errors to pass anyway.
            .assertNonEmptyPromise() // It theoretically throws fatalError on Promise empty completion
                                     // But upstream is a promise and it will never complete without values
                                     // and Retry will ensure to only complete once the upstream (Promise) completes
                                     // with success, therefore, with one value.
    }
}
