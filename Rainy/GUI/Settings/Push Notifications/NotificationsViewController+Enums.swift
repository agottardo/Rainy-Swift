//
//  NotificationsViewController+Enums.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-05-23.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import Foundation

extension NotificationsViewController {
    enum Section: Int, CaseIterable, Localizable {
        case enableAndLocation
        case notifications

        var localizedString: String {
            switch self {
            case .enableAndLocation:
                return ""
            case .notifications:
                return "Active notifications"
            }
        }
    }

    enum EnableCell: Int, CaseIterable, Localizable {
        case enable
        case location

        var localizedString: String {
            switch self {
            case .enable:
                return "Enable"
            case .location:
                return "Location"
            }
        }
    }

    enum NotificationCell: Int, CaseIterable, Localizable {
        case morning
        case evening
        case alerts
        case rainNotification

        var localizedString: String {
            switch self {
            case .morning:
                return "Morning Briefing"

            case .evening:
                return "Evening Briefing"

            case .alerts:
                return "Weather Alerts"

            case .rainNotification:
                return "Rain Notification"
            }
        }

        var longDescription: String {
            switch self {
            case .morning:
                return "Forecast for the day, delivered at 7 in the morning."

            case .evening:
                return "Forecast for the following day. Delivered at 9 in the evening."

            case .alerts:
                return "Weather alerts, watches and advisories issued by your local weather service."

            case .rainNotification:
                return "Issued if a moderate to high amount of rain is expected in your location within the following 6 hours."
            }
        }
    }
}
