//
//  WeatherUpdate.swift
//  Rainy
//
//  Created by Andrea Gottardo on 11/11/17.
//  Copyright © 2017 Andrea Gottardo. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: - WeatherUpdate
struct WeatherUpdate: Codable {
    let latitude, longitude: Double?
    let timezone: String?
    let currently: Currently?
    let hourly: Hourly?
    let daily: Daily?
    let offset: Int?
}

// MARK: - Currently
struct Currently: Codable {
    let time: Int?
    let summary: String?
    let icon: String?
    let precipIntensity, precipProbability, temperature, apparentTemperature: Double?
    let dewPoint, humidity, pressure, windSpeed: Double?
    let windGust: Double?
    let windBearing: Int?
    let cloudCover: Double?
    let uvIndex: Int?
    let visibility, ozone: Double?
    let precipType: String?
}

// MARK: - Daily
struct Daily: Codable {
    let summary: String?
    let icon: String?
    let data: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    let time: Int?
    let summary, icon: String?
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
struct Hourly: Codable {
    let summary: String?
    let icon: String?
    let data: [Currently]?
}
