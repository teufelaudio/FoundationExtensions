// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import Foundation
import Combine
extension MutableParameter: Codable where T: Codable {
    enum CodingKeys: String, CodingKey {
        case type
        case associatedValues

        enum ValueKeys: String, CodingKey {
            case associatedValue0
        }
        enum ChangingKeys: String, CodingKey {
            case old
            case new
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(String.self, forKey: .type) {
        case "value":
            let subContainer = try container.nestedContainer(keyedBy: CodingKeys.ValueKeys.self, forKey: .associatedValues)
            let associatedValues0 = try subContainer.decode(T.self, forKey: .associatedValue0)
            self = .value(associatedValues0)
        case "changing":
            let subContainer = try container.nestedContainer(keyedBy: CodingKeys.ChangingKeys.self, forKey: .associatedValues)
            let associatedValues0 = try subContainer.decode(T.self, forKey: .old)
            let associatedValues1 = try subContainer.decode(T.self, forKey: .new)
            self = .changing(old: associatedValues0, new: associatedValues1)
        default:
            throw DecodingError.keyNotFound(CodingKeys.type, .init(codingPath: container.codingPath, debugDescription: "Unknown key"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .value(associatedValue0):
            try container.encode("value", forKey: .type)
            var subContainer = container.nestedContainer(keyedBy: CodingKeys.ValueKeys.self, forKey: .associatedValues)
            try subContainer.encode(associatedValue0, forKey: .associatedValue0)
        case let .changing(old, new):
            try container.encode("changing", forKey: .type)
            var subContainer = container.nestedContainer(keyedBy: CodingKeys.ChangingKeys.self, forKey: .associatedValues)
            try subContainer.encode(old, forKey: .old)
            try subContainer.encode(new, forKey: .new)
        }
    }
}
