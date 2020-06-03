//
//  DistributionEnvironment.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 27.01.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

public enum DistributionEnvironment: String {

    /// Release on App Store
    case appStore = "RELEASE"
    /// Beta on Testflight
    case testFlight = "TESTFLIGHT"
    /// Internal Beta with Enterprise Distribution
    case teamInternal = "INTERNAL"
    /// Programmer working
    case debug
    /// App is running as host target for unit tests
    case runningTests

    public static var isAppStore: Bool {
        return current == .appStore
    }

    public static var current: DistributionEnvironment {
        // We are passing the launch argument `-TESTING` when running
        // the Tests.
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("-TESTING") {
            return .runningTests
        }
        #endif

        guard let buildArg = Bundle.main.infoDictionary?["TeufelBuildType"] as? String,
            let build = DistributionEnvironment(rawValue: buildArg) else {
                return .debug
        }
        return build
    }

    public static func isOneOf(_ environments: DistributionEnvironment...) -> Bool {
        return environments.contains(current)
    }
}
