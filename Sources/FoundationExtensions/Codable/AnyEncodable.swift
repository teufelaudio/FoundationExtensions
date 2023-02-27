// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

/// Type-erasure for Encodable type
public struct AnyEncodable: Encodable {
    private var encodeFunc: (Encoder) throws -> Void

    public init(_ encodable: Encodable) {
        func internalEncode(to encoder: Encoder) throws {
            try encodable.encode(to: encoder)
        }

        self.encodeFunc = internalEncode
    }

    public func encode(to encoder: Encoder) throws {
        try encodeFunc(encoder)
    }
}

// MARK: - Encodable x AnyEncodable
extension Encodable {
    /// Creates an AnyEncodable out of the receiver.
    /// - Returns: AnyEncodable that contains the encoding function of the receiver.
    public var anyEncodable: AnyEncodable {
        return AnyEncodable(self)
    }
}
