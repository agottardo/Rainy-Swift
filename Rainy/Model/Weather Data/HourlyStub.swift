//
//  HourlyStub.swift
//  Rainy
//
//  Created by Andrea Gottardo on 10/11/17.
//  Copyright © 2017 Andrea Gottardo. All rights reserved.
//

import Foundation

/**
 A piece of weather information relative to a 60-minutes interval
 of the day, containing data such as temperature, wind speed or
 humidity.
 We are not using many of these fields, but since the data is there...
 let's fetch it, maybe we'll use it in the future.
 */
struct HourlyStub {
    let temperature: Double
    let time: Date
    let hourSummary: String
    let precipIntensity: Double
    let precipProbability: Double
}
