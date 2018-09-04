//
//  DarkSkyProvider.swift
//  Rainy
//
//  Created by Andrea Gottardo on 10/11/17.
//  Copyright © 2017 Andrea Gottardo. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

/**
 A Provider that implements the DarkSky.net API.
 */
final class DarkSkyProvider: Provider {

    static let BaseUrl = "https://api.darksky.net/forecast/1e9b4ab3c751d4dab0fbb82f3dab1737/"
    // 10 seconds before network requests timeouts.
    static let MaxTimeOutLimit = TimeInterval(10)

    /**
     Single point of entry into the provider. Data is returned to the
     ViewController via the completion handler.
    */
    func getWeatherDataForCoordinates(coordinates: CLLocationCoordinate2D,
                                      completion: @escaping (_ data: WeatherUpdate?, _ error: ProviderError?) -> Void) {

        // Start spinning the networking activity indicator. Will be stopped
        // at the end of parsing.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        // Setup a HTTP request to the API, using the default caching policy
        // for HTTP.
        let urlSession = URLSession(configuration: URLSessionConfiguration.ephemeral)
        let requestURL = URL(string: DarkSkyProvider.BaseUrl+String(coordinates.latitude)+","+String(coordinates.longitude))!
        // 10 seconds timeout?
        let urlRequest = URLRequest(url: requestURL,
                                    cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy,
                                    timeoutInterval: DarkSkyProvider.MaxTimeOutLimit)

        let task = urlSession.dataTask(with: urlRequest) { (data, _, _) in
            guard data != nil else {
                // Networking error: unable to obtain data from the API.
                completion(nil, ProviderError.network)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!,
                                                            options: []) as? [String: Any]
                completion(self.parseJSON(data: json), nil)
            } catch {
                // Unable to convert the JSON dictionary into a Swift dictionary.
                completion(nil, ProviderError.parsing)
            }
        }
        // Start the HTTP request.
        task.resume()
    }

    /**
     Parses the dictionary coming from the API, and returns it as a nice
     WeatherUpdate instance. 🌦
    */
    func parseJSON(data: [String: Any]?) -> WeatherUpdate? {
        
        if let hourly = data?["hourly"] as? [String: Any],
           let currently = data?["currently"] as? [String: Any] {
            
            let currentCondition: String = currently["summary"] as! String
            let currentTemp: Double = currently["temperature"] as! Double
            let hourlyData: [[String: Any]] = hourly["data"] as! [[String: Any]]
            var hourlyStubs = [HourlyStub]()
            for hourlyStub in hourlyData {
                // For each piece of hourly weather information, we construct
                // a HourlyStub. Now, a lot of data we don't really use is added.
                if let temperature = hourlyStub["temperature"] as? Double,
                    let hourSummary = hourlyStub["summary"] as? String,
                    let precipIntensity = hourlyStub["precipIntensity"] as? Double,
                    let precipProbability = hourlyStub["precipProbability"] as? Double,
                    let time = hourlyStub["time"] as? Int {
                        
                    let nstime = Date.init(timeIntervalSince1970: TimeInterval(time))
                    let hourlyStub = HourlyStub(temperature: temperature,
                                                time: nstime,
                                                hourSummary: hourSummary,
                                                precipIntensity: precipIntensity,
                                                precipProbability: precipProbability)
                    hourlyStubs.append(hourlyStub)
                    
                } else {
                    return nil
                }
            }
            let weatherUpdate = WeatherUpdate(stubs: hourlyStubs,
                                              currentCondition: currentCondition,
                                              currentTemperature: currentTemp)
            DispatchQueue.main.async {
                // Stop the networking activity indicator.
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            return weatherUpdate
        } else {
            return nil
        }
    }
}
