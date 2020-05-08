//
//  WeatherUpdate.swift
//  Rainy
//
//  Created by Andrea Gottardo on 11/11/17.
//  Copyright © 2017 Andrea Gottardo. All rights reserved.
//

import Foundation
import UIKit

/// A Swift Codable representing the response returned by the DarkSky.net API.
struct WeatherUpdate: Codable {
    let latitude, longitude: Double?
    let timezone: String?
    let currently: HourCondition?
    let hourly: HourlyData?
    let daily: DailyData?
    let offset: Int?
    let alerts: [WeatherAlert]?
}

/// Represents the weather conditions for a 1-hour interval starting at `time`.
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

/// Represents the weather conditions for multiple days. The number of days returned (`==data.count`)
/// depends on the location and data availability.
struct DailyData: Codable {
    let summary: String?
    let icon: String?
    let data: [DailyCondition]?
}

/// Represents the weather conditions for a 24-hours interval.
struct DailyCondition: Codable {
    let time: Int?
    let summary: String?
    let icon: WeatherIcon?
    let sunriseTime, sunsetTime: Int?
    let moonPhase, precipIntensity, precipIntensityMax: Double?
    let precipIntensityMaxTime: Int?
    let precipProbability: Double?
    let precipType: String?
    let temperatureHigh: Temperature?
    let temperatureHighTime: Int?
    let temperatureLow: Temperature?
    let temperatureLowTime: Int?
    let apparentTemperatureHigh: Temperature?
    let apparentTemperatureHighTime: Int?
    let apparentTemperatureLow: Temperature?
    let apparentTemperatureLowTime: Int?
    let dewPoint, humidity, pressure, windSpeed: Double?
    let windGust: Double?
    let windGustTime, windBearing: Int?
    let cloudCover: Double?
    let uvIndex, uvIndexTime: Int?
    let visibility, ozone: Double?
    let temperatureMin: Temperature?
    let temperatureMinTime: Int?
    let temperatureMax: Temperature?
    let temperatureMaxTime: Int?
    let apparentTemperatureMin: Temperature?
    let apparentTemperatureMinTime: Int?
    let apparentTemperatureMax: Temperature?
    let apparentTemperatureMaxTime: Int?
}

/// Represents the weather conditions for multiple hours. The number of hours returned (`==data.count`)
/// depends on the location and data availability.
struct HourlyData: Codable {
    let summary: String?
    let icon: WeatherIcon?
    let data: [HourCondition]?
}
