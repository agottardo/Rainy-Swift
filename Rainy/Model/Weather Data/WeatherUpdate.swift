//
//  WeatherUpdate.swift
//  Rainy
//
//  Created by Andrea Gottardo on 11/11/17.
//  Copyright © 2017 Andrea Gottardo. All rights reserved.
//

import Foundation
import CoreLocation

/**
 A bucket of weather data coming straight from the API.
*/
class WeatherUpdate {

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
