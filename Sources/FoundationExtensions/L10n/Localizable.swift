// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

@available(iOS 13.0, *)
public protocol Localizable {
    var key: LocalizedStringKey { get }
    var rootKey: String { get }
}

@available(iOS 13.0, *)
extension Localizable {
    public var key: LocalizedStringKey {
        .init(
            "\(rootKey).\(Mirror(reflecting: self).children.first?.label ?? "\(self)")"
        )
    }

    public var rootKey: String {
        String(reflecting: Self.self)
    }
}
