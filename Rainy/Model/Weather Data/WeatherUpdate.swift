//
//  WeatherUpdate.swift
//  Rainy
//
//  Created by Andrea Gottardo on 11/11/17.
//  Copyright © 2017 Andrea Gottardo. All rights reserved.
//

import CoreLocation
import Foundation
import UIKit

// MARK: - WeatherUpdate

struct WeatherUpdate: Codable {
    let latitude, longitude: Double?
    let timezone: String?
    let currently: HourCondition?
    let hourly: HourlyData?
    let daily: DailyData?
    let offset: Int?
}

class Temperature: Codable {
    private let doubleValue: Double

    func stringRepresentation(settingsManager: SettingsManager = .shared) -> String {
        switch settingsManager.temperatureUnit {
        case .celsius:
            return String(lround(0.55555 * (doubleValue - 32))) + "°"
        case .fahrenheit:
            return String(lround(doubleValue)) + "°"
        }
    }

    init(_ double: Double) {
        doubleValue = double
    }

    required init(from: Decoder) {
        do {
            let container = try from.singleValueContainer()
            doubleValue = try container.decode(Double.self)
        } catch {
            Log.error("Failed to parse temperature, not a double.")
            doubleValue = 0
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(doubleValue)
    }
}

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
        let configuration: UIImage.SymbolConfiguration = .init(weight: .light)
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

// MARK: - Currently

struct HourCondition: Codable {
    let time: Int?
    let summary: String?
    let icon: WeatherIcon?
    let precipIntensity, precipProbability: Double?
    let apparentTemperature: Temperature?
    let temperature: Temperature?
    let dewPoint, humidity, pressure, windSpeed: Double?
    let windGust: Double?
    let windBearing: Int?
    let cloudCover: Double?
    let uvIndex: Int?
    let visibility, ozone: Double?
    let precipType: String?
}

// MARK: - Daily

struct DailyData: Codable {
    let summary: String?
    let icon: String?
    let data: [Datum]?
}

// MARK: - Datum

struct Datum: Codable {
    let time: Int?
    let summary: String?
    let icon: WeatherIcon?
    let sunriseTime, sunsetTime: Int?
    let moonPhase, precipIntensity, precipIntensityMax: Double?
    let precipIntensityMaxTime: Int?
    let precipProbability: Double?
    let precipType: String?
    let temperatureHigh: Double?
    let temperatureHighTime: Int?
    let temperatureLow: Double?
    let temperatureLowTime: Int?
    let apparentTemperatureHigh: Double?
    let apparentTemperatureHighTime: Int?
    let apparentTemperatureLow: Double?
    let apparentTemperatureLowTime: Int?
    let dewPoint, humidity, pressure, windSpeed: Double?
    let windGust: Double?
    let windGustTime, windBearing: Int?
    let cloudCover: Double?
    let uvIndex, uvIndexTime: Int?
    let visibility, ozone, temperatureMin: Double?
    let temperatureMinTime: Int?
    let temperatureMax: Double?
    let temperatureMaxTime: Int?
    let apparentTemperatureMin: Double?
    let apparentTemperatureMinTime: Int?
    let apparentTemperatureMax: Double?
    let apparentTemperatureMaxTime: Int?
}

// MARK: - Hourly

struct HourlyData: Codable {
    let summary: String?
    let icon: WeatherIcon?
    let data: [HourCondition]?
}
