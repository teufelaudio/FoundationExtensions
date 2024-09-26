// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

extension Int: Error { }

struct TestJson: Codable, Equatable {
    let name: String
    let result: Result<[Int: String], String>
}

let successObject: TestJson = .init(name: "Success", result: .success([1: "foo", 2: "bar"]))
let successJson1 = "{\"name\":\"Success\",\"result\":{\"success\":{\"1\":\"foo\",\"2\":\"bar\"}}}"
let successJson2 = "{\"name\":\"Success\",\"result\":{\"success\":{\"2\":\"bar\",\"1\":\"foo\"}}}"
let successJson3 = "{\"result\":{\"success\":{\"1\":\"foo\",\"2\":\"bar\"}},\"name\":\"Success\"}"
let successJson4 = "{\"result\":{\"success\":{\"2\":\"bar\",\"1\":\"foo\"}},\"name\":\"Success\"}"
let failureObject: TestJson = .init(name: "Failure", result: .failure("This is an error"))
let failureJson1 = "{\"name\":\"Failure\",\"result\":{\"failure\":\"This is an error\"}}"
let failureJson2 = "{\"result\":{\"failure\":\"This is an error\"},\"name\":\"Failure\"}"
