//
//  TimerProtocol.swift
//  FoundationExtensions
//
//  Created by Luiz Barbosa on 12.03.19.
//  Copyright © 2019 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation

// sourcery: AutoMockable
public protocol TimerProtocol: class {
    func fire()
    var fireDate: Date { get set }
    var timeInterval: TimeInterval { get }
    var tolerance: TimeInterval { get set }
    func invalidate()
    var isValid: Bool { get }
    var userInfo: Any? { get }
}

public struct TimerScheduler {
    public let timeInterval: TimeInterval
    public let repeats: Bool
    public let block: (TimerProtocol) -> Void

    public init(timeInterval: TimeInterval, repeats: Bool, block: @escaping (TimerProtocol) -> Void) {
        self.timeInterval = timeInterval
        self.repeats = repeats
        self.block = block
    }
}

extension Timer: TimerProtocol {
}
