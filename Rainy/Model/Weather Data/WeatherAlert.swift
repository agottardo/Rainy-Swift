//
//  WeatherAlert.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-14.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import Foundation
import UIKit

struct WeatherAlert: Codable {
    enum Severity: String, Codable {
        case advisory
        case watch
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
