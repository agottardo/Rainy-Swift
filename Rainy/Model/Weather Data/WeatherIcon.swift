//
//  WeatherIcon.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-05-07.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import Foundation
import UIKit

/// Icon representing a weather condition.
enum WeatherIcon: String, Codable {
    case clearDay = "clear-day"
    case clearNight = "clear-night"
    case rain
    case snow
    case sleet
    case wind
    case fog
    case cloudy
    case partlyCloudyDay = "partly-cloudy-day"
    case partlyCloudyNight = "partly-cloudy-night"
    case hail
    case thunderstorm
    case tornado

    var icon: UIImage? {
        let configuration: UIImage.SymbolConfiguration = .init(weight: .regular)
        switch self {
        case .clearDay:
            return UIImage(systemName: "sun.max", withConfiguration: configuration)
        case .clearNight:
            return UIImage(systemName: "moon.stars", withConfiguration: configuration)
        case .rain:
            return UIImage(systemName: "cloud.rain", withConfiguration: configuration)
        case .snow:
            return UIImage(systemName: "cloud.snow", withConfiguration: configuration)
        case .sleet:
            return UIImage(systemName: "cloud.sleet", withConfiguration: configuration)
        case .wind:
            return UIImage(systemName: "wind", withConfiguration: configuration)
        case .fog:
            return UIImage(systemName: "cloud.fog", withConfiguration: configuration)
        case .cloudy:
            return UIImage(systemName: "cloud", withConfiguration: configuration)
        case .partlyCloudyDay:
            return UIImage(systemName: "cloud.sun", withConfiguration: configuration)
        case .partlyCloudyNight:
            return UIImage(systemName: "cloud.moon", withConfiguration: configuration)
        case .hail:
            return UIImage(systemName: "cloud.hail", withConfiguration: configuration)
        case .tornado:
            return UIImage(systemName: "tornado", withConfiguration: configuration)
        case .thunderstorm:
            return UIImage(systemName: "cloud.bolt", withConfiguration: configuration)
        }
    }
}
