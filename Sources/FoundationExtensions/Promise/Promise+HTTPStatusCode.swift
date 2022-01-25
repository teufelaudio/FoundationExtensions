import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.Promise where Success == (data: Data, response: URLResponse), Failure == URLError {
    public func validStatusCode() -> Publishers.Promise<Void, URLError> {
        flatMapResult { _, response -> Result<Void, URLError> in
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(URLError(.badServerResponse))
            }

            return (200..<400) ~= httpResponse.statusCode
                ? .success(())
                : .failure(URLError(.badServerResponse))
        }
    }
}
