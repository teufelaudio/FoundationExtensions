// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

/// Allows to turn the Type-hierarchy into a string, i.e. "`Superclass.Subclass`".
public protocol TypePathConvertible {
    var typePath: String { get }
}

extension TypePathConvertible {
    public var typePath: String {
        let reflectionString = String(reflecting: self)

        // Regex: "\.\([^\)]*\)" matches .("anything but a closing brace")
        guard let regex = try? NSRegularExpression(pattern: "\\.\\([^\\)]*\\)", options: NSRegularExpression.Options.caseInsensitive) else {
            return String(describing: self)
        }
        // Remove anonymous types that appear in unit testing, i.e. "A.B.C.(unknown context at $1071608c4).(unknown context at $107160918).yak"
        return regex.stringByReplacingMatches(in: reflectionString,
                                              options: [],
                                              range: NSMakeRange(0, reflectionString.count),
                                              withTemplate: "")
    }
}
