// Copyright © 2021 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(CryptoKit)
import CryptoKit
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Data {
    /// MD5 is broken. Use at your (and your customers) own risk.
    public var md5: Data {
        return Data(Insecure.MD5.hash(data: self).compactMap { UInt8($0) })
    }

    /// MD5 is broken. Use at your (and your customers) own risk.
    public var md5String: String {
        return Insecure.MD5.hash(data: self).hexString(withPrefix: false)
    }

    /// Returns the last 4 bytes of the MD5 hash as file identifier.
    public var md5Identifier: Data? {
        let hash = md5
        guard hash.count == 16 else { return nil }
        return hash.range(start: 16 - 4, length: 4)
    }
}

#endif
