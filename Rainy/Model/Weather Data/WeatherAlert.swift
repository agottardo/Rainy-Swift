//
//  WeatherAlert.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-14.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import Foundation
import UIKit

/// Represents a weather alert, advisory or watch provided by the API.
struct WeatherAlert: Codable {
    enum Severity: String, Codable {
        /// Low priority
        case advisory
        /// Medium priority
        case watch
        /// High priority
        case warning

        var localizedString: String {
            switch self {
            case .advisory:
                return "Advisory"
            case .watch:
                return "Watch"
            case .warning:
                return "Warning"
            }
        }

        /// The color used in the bar at the top of the home screen to represent this alert.
        var color: UIColor {
            switch self {
            case .advisory:
                return .systemBlue
            case .watch:
                return .systemOrange
            case .warning:
                return .systemRed
            }
        }

        var icon: UIImage? {
            switch self {
            case .advisory:
                return UIImage(systemName: "info.circle.fill")
            case .watch:
                return UIImage(systemName: "exclamationmark.square.fill")
            case .warning:
                return UIImage(systemName: "exclamationmark.triangle.fill")
            }
        }
    }

    let title: String
    let regions: [String]?
    let severity: Severity
    let time: Int?
    let expires: Int?
    let description: String?
    let uri: URL?
}
