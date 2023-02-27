// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

class AnyError: Error, Equatable, Codable {
}

func == (lhs: AnyError, rhs: AnyError) -> Bool {
    return lhs === rhs
}
