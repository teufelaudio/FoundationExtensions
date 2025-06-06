//
//  Duration+Extensions.swift
//  FoundationExtensions
//
//  Created by Lukas Liebl on 06.06.25.
//

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension Duration {
    public static func minutes(_ minutes: Int32) -> Duration {
        .seconds(Int64(minutes) * 60)
    }
    
    public static func hours(_ hours: Int32) -> Duration {
        .seconds(Int64(hours) * 60 * 60)
    }
}

