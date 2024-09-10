// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

extension Data {

    public struct MatchMask: CustomStringConvertible {
        let expected: Data
        let mask: Data

        public init(expected: Data, mask: Data? = nil) {
            self.expected = expected

            // If the mask is provided and is shorter than expected, fill it up with 0xff until it matches the length of expected
            if let providedMask = mask {
                if providedMask.count < expected.count {
                    // Fill the remaining bytes with 0xff
                    self.mask = providedMask + Data(repeating: 0xff, count: expected.count - providedMask.count)
                } else {
                    self.mask = providedMask
                }
            } else {
                // If the mask is not provided, use a series of 0xFF
                self.mask = Data(repeating: 0xFF, count: expected.count)
            }

        }


        /// Prints the mask as hex string. Depening on the mask bits, the output is different
        ///
        /// * "AA": No mask applied (0x00), so the output for this byte is the hex representation.
        /// * "..": At least one bit is masked (0x01), so the output for this byte is ".."
        /// * "::": All bits are masked (0xFF), so the output for this byte is ":".
        ///  Example usage:
        ///
        ///  ```
        ///  let data = Data([0b10101010, 0b11001100, 0b11110000])
        ///  let expected = Data([0b10101010, 0b11001111, 0b11110000])
        ///  let mask = Data([0b11111111, 0b11111110])  // Only 2 bytes provided, second byte misses last bit (0xfe)
        ///  let matchMask = Data.MatchMask(expected: expected, mask: mask)
        ///
        ///  let hexString = matchMask.description
        ///  print(hexString)  // Output: "0xaa..f0"
        ///  ```
        public var description: String {
            var hexString = ""

            for (index, byte) in expected.enumerated() {
                if mask.count <= index {
                    break
                }
                let maskByte = mask[index]

                if maskByte == 0xFF {  // All bits are set
                    hexString += "::"
                } else if maskByte != 0x00 {  // At least one bit is set
                    hexString += ".."
                } else {
                    // No bits are set; output the hex representation of the expected byte
                    hexString += String(format: "%02x", byte)
                }
            }

            return "0x\(hexString)"
        }
    }

    ///  Will return true if the masked content of data matches expected.
    ///
    ///  Example usage:
    ///
    ///  ```
    ///  let data = Data([0b10101010, 0b11001100, 0b11110000])
    ///  let expected = Data([0b10101010, 0b11001111, 0b11110000])
    ///  let mask = Data([0b11111111, 0b11111110])  // Only 2 bytes provided
    ///  let matchMask = Data.MatchMask(expected: expected, mask: mask)
    ///
    ///  let result = data.matches(matchMask)
    ///  print(result)  // Output: true
    ///
    ///  let hexString = matchMask.description
    ///  print(hexString)  // Output: "0xaa..f0"
    ///  ```
    ///
    /// - Parameter match: A MatchMask containing the expected bytes and the bitmask to apply before comparing
    /// - Returns: Returns true, if the expected bytes match our bytes, respecting the mask.
    public func matches(_ match: MatchMask) -> Bool {
        guard self.count == match.expected.count, match.expected.count == match.mask.count else {
            return false
        }

        for (index, byte) in self.enumerated() {
            let maskedByte = byte & match.mask[index]  // Apply mask to the actual byte
            let expectedByte = match.expected[index] & match.mask[index]  // Apply mask to the expected byte

            if maskedByte != expectedByte {
                return false
            }
        }

        return true
    }
}
