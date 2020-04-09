//
//  Logger.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-07.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import Foundation
import os
import Sentry

class Log {
    enum Level {
        case error
        case warning
        case info
        case debug

        var shouldBeUploadedToSentry: Bool {
            self == .error
        }

        var osLogType: OSLogType {
            switch self {
            case .error:
                return .error
            case .warning:
                return .fault
            case .info:
                return .info
            case .debug:
                return .debug
            }
        }

        var sentrySeverity: SentrySeverity {
            switch self {
            case .error:
                return .error
            case .warning:
                return .warning
            case .info:
                return .info
            case .debug:
                return .debug
            }
        }
    }

    private static func log(_ level: Level, message: String) {
        os_log("%@", type: level.osLogType, message)
        if level.shouldBeUploadedToSentry {
            let sentryEvent = Event(level: level.sentrySeverity)
            sentryEvent.message = message
            Client.shared?.send(event: sentryEvent, completion: nil)
        }
    }

    static func error(_ message: String) {
        Log.log(.error, message: message)
    }

    static func warning(_ message: String) {
        Log.log(.warning, message: message)
    }

    static func info(_ message: String) {
        Log.log(.info, message: message)
    }

    static func debug(_ message: String) {
        Log.log(.debug, message: message)
    }
}
