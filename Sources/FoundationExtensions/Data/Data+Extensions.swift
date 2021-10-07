//
//  Data+Extensions.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 12.07.19.
//  Copyright © 2019 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

extension Data {
    public mutating func replaceBytes<T>(with value: T, offset: Data.Index) {
        if let data = value as? Data {
            replaceSubrange(offset..<(offset + data.count), with: data)
            return
        }

        let size = MemoryLayout<T>.size
        precondition((0...count).contains(offset + size), "Bytes don't fit current Data range")

        var mutableCopy = value
        replaceSubrange(offset..<(offset + size), with: Data(bytes: &mutableCopy, count: size))
    }
}

extension Numeric {
    public func toData() -> Data {
        var selfCopy = self
        let size = MemoryLayout<Self>.size
        return Data(bytes: &selfCopy, count: size)
    }
}

extension Data {

    public func range(start: Int, length: Int) -> Data {
        guard start < endIndex else { return Data() }
        let end = Swift.min(endIndex, start + length)
        return subdata(in: start ..< end)
    }

    public func readValue<T>() -> T {
        withUnsafeBytes { pointer in
            pointer.load(as: T.self)
        }
    }

    public func readFixedWidth<T: FixedWidthInteger>(bigEndian: Bool) -> T {
        let value: T = readValue()
        return bigEndian ? value.bigEndian : value
    }

    public func readInt32(bigEndian: Bool) -> Int32 {
        let value: Int32 = readValue()
        return bigEndian ? value.bigEndian : value
    }

    public func readUInt32(bigEndian: Bool) -> UInt32 {
        let value: UInt32 = readValue()
        return bigEndian ? value.bigEndian : value
    }

    public func readInt16(bigEndian: Bool) -> Int16 {
        let value: Int16 = readValue()
        return bigEndian ? value.bigEndian : value
    }

    public func readUInt16(bigEndian: Bool) -> UInt16 {
        let value: UInt16 = readValue()
        return bigEndian ? value.bigEndian : value
    }

    public func readInt8() -> Int8 {
        readValue()
    }

    public func readUInt8() -> UInt8 {
        readValue()
    }

    public func readBool() -> Bool {
        readUInt8() == 1
    }

    public func readString() -> String {
        String(data: self, encoding: .utf8) ?? ""
    }

    public func readMirroredString() -> String {
        String(readString().reversed())
    }

    public func readPercentage(bigEndian: Bool) -> Float {
        let signedIntScale = readInt32(bigEndian: bigEndian)
        let percentage = 0.5 + Float(signedIntScale) / Float(UInt32.max)
        return percentage
    }

    public func readVarint() -> Int32 {
        self.range(start: 0, length: 4).map { $0 }.readVarint()!
    }
}

extension Sequence where Element == UInt8 {
    public func readVarint() -> Int32? {
        var position = 0
        var shift = 25
        var bitPattern: UInt32 = 0x0

        for byte in self {
            bitPattern = bitPattern | (UInt32(byte & 0x7F) << shift)

            if position == 3 {
                bitPattern = bitPattern | (UInt32(byte & 0x78) >> 3)
                break
            }

            position += 1
            shift -= 7
        }

        guard position == 3 else { return nil }
        return Int32(bitPattern: bitPattern)
    }
}
