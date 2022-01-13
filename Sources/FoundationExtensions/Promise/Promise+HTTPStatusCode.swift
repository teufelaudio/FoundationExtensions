import Combine
import Foundation

extension Publishers.Promise where Success == (data: Data, response: URLResponse), Failure == URLError {
    public func validStatusCode() -> Publishers.Promise<Void, URLError> {
        flatMap { _, response -> Publishers.Promise<Void, URLError> in
            guard let httpResponse = response as? HTTPURLResponse else {
                return Publishers.Promise(error: URLError(.badServerResponse))
            }

            return (200..<400) ~= httpResponse.statusCode
                ? Publishers.Promise(value: ())
                : Publishers.Promise(error: URLError(.badServerResponse))
        }
    }
}
