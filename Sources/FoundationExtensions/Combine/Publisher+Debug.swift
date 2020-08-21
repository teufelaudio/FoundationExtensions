//
//  Publisher+Debug.swift
//  FoundationExtensions
//
//  Created by Luis Reisewitz on 20.08.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//


#if canImport(Combine) && canImport(Foundation)
import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher where Failure == URLError, Output == (data: Data, response: URLResponse) {
    public func maybePrintStringBody(_ print: Bool,
                                     encoding: String.Encoding = .utf8,
                                     file: String = #file,
                                     line: Int = #line,
                                     function: String = #function) -> Publishers.Map<Self, Output> {
        return self
            .map {
                guard print else { return $0 }
                let string = String(data: $0.data, encoding: encoding)
                Swift.print("\(file):\(line): Publisher \(type(of: self)) in function \(function) received following HTTP response: \n\(String(describing: string))")
                return $0
            }
    }
}

#endif
