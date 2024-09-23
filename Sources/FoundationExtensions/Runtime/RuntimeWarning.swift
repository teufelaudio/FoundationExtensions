// Copyright (c) 2021 Point-Free, Inc.
//
// RuntimeWarning adopted from
// https://github.com/pointfreeco/swift-issue-reporting/blob/b22b6ae2f7633170565e5888e8ed7950b2990e9c/Sources/IssueReporting/IssueReporters/RuntimeWarningReporter.swift

import Foundation

#if canImport(os)
  import os
#endif

@_transparent
@inline(__always)
public func runtimeWarning(
    _ message: @autoclosure () -> String?,
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column
) {
    _RuntimeWarningReporter()
        .reportIssue(
            message(),
            fileID: fileID,
            filePath: filePath,
            line: line,
            column: column
        )
}

public struct _RuntimeWarningReporter {
  #if canImport(os)
    @UncheckedSendable
    #if canImport(Darwin)
      @_transparent
    #endif
    @usableFromInline var dso: UnsafeRawPointer

    init(dso: UnsafeRawPointer) {
      self.dso = dso
    }

    @usableFromInline
    init() {
      // NB: Xcode runtime warnings offer a much better experience than traditional assertions and
      //     breakpoints, but Apple provides no means of creating custom runtime warnings ourselves.
      //     To work around this, we hook into SwiftUI's runtime issue delivery mechanism, instead.
      //
      // Feedback filed: https://gist.github.com/stephencelis/a8d06383ed6ccde3e5ef5d1b3ad52bbc
      let count = _dyld_image_count()
      for i in 0..<count {
        if let name = _dyld_get_image_name(i) {
          let swiftString = String(cString: name)
          if swiftString.hasSuffix("/SwiftUI") {
            if let header = _dyld_get_image_header(i) {
              self.init(dso: UnsafeRawPointer(header))
              return
            }
          }
        }
      }
      self.init(dso: #dsohandle)
    }
  #endif

  @_transparent
  public func reportIssue(
    _ message: @autoclosure () -> String?,
    fileID: StaticString,
    filePath: StaticString,
    line: UInt,
    column: UInt
  ) {
    #if canImport(os)
      let moduleName = String(
        Substring("\(fileID)".utf8.prefix(while: { $0 != UTF8.CodeUnit(ascii: "/") }))
      )
      var message = message() ?? ""
      if message.isEmpty {
        message = "Issue reported"
      }
      os_log(
        .fault,
        dso: dso,
        log: OSLog(subsystem: "com.apple.runtime-issues", category: moduleName),
        "%@",
        "\(message)"
      )
    #else
      printError("\(fileID):\(line): \(message() ?? "")")
    #endif
  }
}

@propertyWrapper
@usableFromInline
struct UncheckedSendable<Value>: @unchecked Sendable {
  @usableFromInline
  var wrappedValue: Value
  init(wrappedValue value: Value) {
    self.wrappedValue = value
  }
}
