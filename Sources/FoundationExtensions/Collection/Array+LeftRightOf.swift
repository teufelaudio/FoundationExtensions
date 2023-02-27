// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

extension Array where Self.Element : Equatable {

    public func left(of element: Element) -> Element? {
        guard let elementIndex = firstIndex(of: element) else { return nil }
        if elementIndex == 0 {
            return self.last
        }
        return self[safe: (elementIndex - 1)]
    }

    public func right(of element: Element) -> Element? {
        guard let elementIndex = firstIndex(of: element) else { return nil }
        if elementIndex >= (count - 1) {
            return self.first
        }
        return self[safe: (elementIndex + 1)]
    }
}
