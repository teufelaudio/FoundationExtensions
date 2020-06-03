//
//  DispatchTimeInterval+Codable.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 30.04.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

extension DispatchTimeInterval: Codable {
    enum CodingKeys: String, CodingKey {
        case type
        case associatedValues

        enum SecondsKeys: String, CodingKey {
            case associatedValue0
        }
        enum MillisecondsKeys: String, CodingKey {
            case associatedValue0
        }
        enum MicrosecondsKeys: String, CodingKey {
            case associatedValue0
        }
        enum NanosecondsKeys: String, CodingKey {
            case associatedValue0
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(String.self, forKey: .type) {
        case "seconds":
            let subContainer = try container.nestedContainer(keyedBy: CodingKeys.SecondsKeys.self, forKey: .associatedValues)
            let associatedValues0 = try subContainer.decode(Int.self, forKey: .associatedValue0)
            self = .seconds(associatedValues0)
        case "milliseconds":
            let subContainer = try container.nestedContainer(keyedBy: CodingKeys.MillisecondsKeys.self, forKey: .associatedValues)
            let associatedValues0 = try subContainer.decode(Int.self, forKey: .associatedValue0)
            self = .milliseconds(associatedValues0)
        case "microseconds":
            let subContainer = try container.nestedContainer(keyedBy: CodingKeys.MicrosecondsKeys.self, forKey: .associatedValues)
            let associatedValues0 = try subContainer.decode(Int.self, forKey: .associatedValue0)
            self = .microseconds(associatedValues0)
        case "nanoseconds":
            let subContainer = try container.nestedContainer(keyedBy: CodingKeys.NanosecondsKeys.self, forKey: .associatedValues)
            let associatedValues0 = try subContainer.decode(Int.self, forKey: .associatedValue0)
            self = .nanoseconds(associatedValues0)
        case "never":
            self = .never
        default:
            throw DecodingError.keyNotFound(CodingKeys.type, .init(codingPath: container.codingPath, debugDescription: "Unknown key"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .seconds(associatedValue0):
            try container.encode("seconds", forKey: .type)
            var subContainer = container.nestedContainer(keyedBy: CodingKeys.SecondsKeys.self, forKey: .associatedValues)
            try subContainer.encode(associatedValue0, forKey: .associatedValue0)
        case let .milliseconds(associatedValue0):
            try container.encode("milliseconds", forKey: .type)
            var subContainer = container.nestedContainer(keyedBy: CodingKeys.MillisecondsKeys.self, forKey: .associatedValues)
            try subContainer.encode(associatedValue0, forKey: .associatedValue0)
        case let .microseconds(associatedValue0):
            try container.encode("microseconds", forKey: .type)
            var subContainer = container.nestedContainer(keyedBy: CodingKeys.MicrosecondsKeys.self, forKey: .associatedValues)
            try subContainer.encode(associatedValue0, forKey: .associatedValue0)
        case let .nanoseconds(associatedValue0):
            try container.encode("nanoseconds", forKey: .type)
            var subContainer = container.nestedContainer(keyedBy: CodingKeys.NanosecondsKeys.self, forKey: .associatedValues)
            try subContainer.encode(associatedValue0, forKey: .associatedValue0)
        case .never:
            try container.encode("never", forKey: .type)
        @unknown default:
            try container.encode("never", forKey: .type)
        }
    }
}
