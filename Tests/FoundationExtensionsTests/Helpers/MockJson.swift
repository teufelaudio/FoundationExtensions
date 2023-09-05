// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

extension Int: Error { }

struct TestJson: Codable, Equatable {
    let name: String
    let result: Result<[Int: String], String>
}

let successObject: TestJson = .init(name: "Success", result: .success([1: "foo", 2: "bar"]))
let successJson1 = "{\"name\":\"Success\",\"result\":{\"success\":{\"1\":\"foo\",\"2\":\"bar\"}}}"
let successJson2 = "{\"name\":\"Success\",\"result\":{\"success\":{\"2\":\"bar\",\"1\":\"foo\"}}}"
let failureObject: TestJson = .init(name: "Failure", result: .failure("This is an error"))
let failureJson = "{\"name\":\"Failure\",\"result\":{\"failure\":\"This is an error\"}}"
