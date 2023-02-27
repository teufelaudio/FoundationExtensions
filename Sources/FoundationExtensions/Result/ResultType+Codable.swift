// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

extension Result: Codable where Success: Codable, Failure: Codable { }

enum ResultTypeCodingKeys: CodingKey {
    case success
    case failure
}

extension ResultType where Success: Codable, Failure: Codable {

    /// Encodes this value into the given encoder.
    ///
    /// If the value fails to encode anything, `encoder` will encode an empty
    /// keyed container in its place.
    ///
    /// This function throws an error if any values are invalid for the given
    /// encoder's format.
    ///
    /// - Parameter encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ResultTypeCodingKeys.self)

        try fold(onSuccess: { value in Result(catching: { try container.encode(value, forKey: .success) }) },
                 onFailure: { error in Result(catching: { try container.encode(error, forKey: .failure) }) })
            .get()
    }

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultTypeCodingKeys.self)
        if container.contains(.success) {
            let value = try container.decode(Success.self, forKey: .success)
            self = Self.init(value: value)
        } else if container.contains(.failure) {
            let error = try container.decode(Failure.self, forKey: .failure)
            self = Self.init(error: error)
        } else {
            throw DecodingError.dataCorruptedError(forKey: .success,
                                                   in: container,
                                                   debugDescription: "The container should have either a value or a error key")
        }
    }
}
