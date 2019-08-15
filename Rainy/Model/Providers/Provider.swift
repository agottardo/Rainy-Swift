//
//  Provider.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2018-09-03.
//  Copyright © 2018 Andrea Gottardo. All rights reserved.
//

import Foundation
import CoreLocation

/**
 A Provider is a source of weather data that builds WeatherUpdates.
 This is implemented as a protocol in order to allow future extensions of the
 app with different data providers in addition to DarkSky.net.
 
 A Provider is composed of two main functions. The first one is the Provider
 single access point, which also takes care of networking. Later on, the Provider
 returns data to the calling ViewController by using a completion handler.
 */
protocol Provider {
    /// Downloads a JSON dictionary from the API.
    func getWeatherDataForCoordinates(coordinates: CLLocationCoordinate2D,
                                      completion: @escaping (Result<WeatherUpdate, NSError>) -> Void)

}
