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
    private struct Constants {
        static let sentryDsn = "https://6940618716d54c108188e82ba381383a@o304136.ingest.sentry.io/5193012"
    }

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

        var sentrySeverity: SentryLevel {
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
            SentrySDK.capture(event: sentryEvent)
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

    static func initializeSentry() {
        // Register the app with Sentry.
        do {
            let sentryOptions = try Options(dict: [
                "dsn": Constants.sentryDsn,
            ])
            sentryOptions.enableAutoSessionTracking = true

            // This feature is strictly opt-in to preserve user privacy, so we check whether
            // the user enabled it and disable the library if the setting value is zero.
            sentryOptions.enabled = SettingsManager.shared.diagnosticsEnabled as NSNumber

            #if DEBUG
                // More verbose logging in development environment.
                sentryOptions.debug = true
            #endif

            SentrySDK.start(options: sentryOptions)
        } catch {
            // Sentry is not yet initialized here, so we cannot use the `Log`.
            print("\(error)")
        }
    }
}
