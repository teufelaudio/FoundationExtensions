//
//  Duration+Extensions.swift
//  FoundationExtensions
//
//  Created by Lukas Liebl on 06.06.25.
//

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension Duration {
    @inlinable public static func minutes<T>(_ minutes: T) -> Duration where T : BinaryInteger {
        .seconds(minutes * 60)
    }
    
    @inlinable public static func hours<T>(_ hours: T) -> Duration where T : BinaryInteger {
        .minutes(hours * 60)
    }
}

