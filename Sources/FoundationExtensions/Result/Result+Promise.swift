// Copyright © 2024 Lautsprecher Teufel GmbH. All rights reserved.

import Combine
import Foundation

extension Result {
    public var promise: Publishers.Promise<Success, Failure> {
        Publishers.Promise(self)
    }
}
