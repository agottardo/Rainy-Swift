//
//  DarkSkyProvider.swift
//  Rainy
//
//  Created by Andrea Gottardo on 10/11/17.
//  Copyright © 2017 Andrea Gottardo. All rights reserved.
//

import CoreLocation
import Foundation
import UIKit

/// A Provider that implements the DarkSky.net API.
final class DarkSkyProvider: Provider {
    struct Constants {
        /// Base API URL
        static let baseUrl = "https://api.darksky.net/forecast/1e9b4ab3c751d4dab0fbb82f3dab1737/"
        /// 10 seconds before network requests timeouts.
        static let maxTimeoutLimit = TimeInterval(10)
    }

    func getWeatherDataForCoordinates(coordinates: CLLocationCoordinate2D,
                                      completion: @escaping (Result<WeatherUpdate, ProviderError>) -> Void) {
        // Setup a HTTP request to the API, using the default caching policy
        // for HTTP.
        let urlSession = URLSession(configuration: URLSessionConfiguration.ephemeral)
        let requestURL = URL(string: Constants.baseUrl + String(coordinates.latitude) + "," + String(coordinates.longitude))!
        let urlRequest = URLRequest(url: requestURL,
                                    cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy,
                                    timeoutInterval: Constants.maxTimeoutLimit)

        let task = urlSession.dataTask(with: urlRequest) { data, _, error in

            if let error = error {
                // Networking error
                Log.warning("Networking error: \(error)")
                completion(.failure(ProviderError.network(networkError: error as NSError)))
                return
            }

            guard let data = data,
                let weatherUpdate = try? JSONDecoder().decode(WeatherUpdate.self, from: data) else {
                Log.error("Parsing failed.")
                completion(.failure(ProviderError.parsing(parsingError: NSError(domain: "parsing", code: -1, userInfo: nil))))
                return
            }
            completion(.success(weatherUpdate))
        }
        // Start the HTTP request.
        task.resume()
    }
}
