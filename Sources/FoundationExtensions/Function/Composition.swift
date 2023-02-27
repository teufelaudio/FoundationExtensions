// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

public func |> <A, B>(_ value: A, f: @escaping (A) -> B) -> B {
    f(value)
}

public func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return { a in
        g(f(a))
    }
}
