//
//  WeatherUpdate.swift
//  Rainy
//
//  Created by Andrea Gottardo on 11/11/17.
//  Copyright © 2017 Andrea Gottardo. All rights reserved.
//

import Foundation
import CoreLocation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//

import Foundation

// MARK: - WeatherUpdate
struct WeatherUpdate: Codable {
    let latitude, longitude: Double?
    let timezone: String?
    let currently: Currently?
    let hourly: Hourly?
    let daily: Daily?
    let alerts: [Alert]?
    let flags: Flags?
    let offset: Int?
}

// MARK: - Alert
struct Alert: Codable {
    let title: String?
    let regions: [String]?
    let severity: String?
    let time, expires: Int?
    let alertDescription: String?
    let uri: String?
    
    enum CodingKeys: String, CodingKey {
        case title, regions, severity, time, expires
        case alertDescription = "description"
        case uri
    }
}

// MARK: - Currently
struct Currently: Codable {
    let time: Int?
    let summary: Summary?
    let icon: Icon?
    let precipIntensity, precipProbability, temperature, apparentTemperature: Double?
    let dewPoint, humidity, pressure, windSpeed: Double?
    let windGust: Double?
    let windBearing: Int?
    let cloudCover: Double?
    let uvIndex: Int?
    let visibility, ozone: Double?
    let precipType: PrecipType?
}

enum Icon: String, Codable {
    case cloudy = "cloudy"
    case partlyCloudyDay = "partly-cloudy-day"
    case partlyCloudyNight = "partly-cloudy-night"
}

enum PrecipType: String, Codable {
    case rain = "rain"
}

enum Summary: String, Codable {
    case mostlyCloudy = "Mostly Cloudy"
    case overcast = "Overcast"
    case partlyCloudy = "Partly Cloudy"
}

// MARK: - Daily
struct Daily: Codable {
    let summary: String?
    let icon: PrecipType?
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
    let precipType: PrecipType?
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

// MARK: - Flags
struct Flags: Codable {
    let sources: [String]?
    let meteoalarmLicense: String?
    let nearestStation: Double?
    let units: String?
    
    enum CodingKeys: String, CodingKey {
        case sources
        case meteoalarmLicense = "meteoalarm-license"
        case nearestStation = "nearest-station"
        case units
    }
}

// MARK: - Hourly
struct Hourly: Codable {
    let summary: String?
    let icon: PrecipType?
    let data: [Currently]?
}


/**
 A bucket of weather data coming straight from the API.
*/
class OldWeatherUpdate {

    let hourlyStubs: [HourlyStub]
    let currentCondition: String
    let currentTemperature: Double

    init(stubs: [HourlyStub], currentCondition: String, currentTemperature: Double) {
        self.hourlyStubs = stubs
        self.currentCondition = currentCondition
        self.currentTemperature = currentTemperature
    }

    /**
     Returns the number of days the forecast spans across.
    */
    var numDays: Int {
        var count: Int = 0
        var lastDay: Int = 0
        let calendar = Calendar.current
        for hourlyStub in hourlyStubs {
            let day = calendar.component(.day, from: hourlyStub.time)
            if day != lastDay {
                count+=1
            }
            lastDay = day
        }
        return count
    }

}
