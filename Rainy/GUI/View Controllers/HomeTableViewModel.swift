//
//  HomeTableViewModel.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2019-08-18.
//  Copyright © 2019 Andrea Gottardo. All rights reserved.
//

import Foundation
import CoreLocation

enum FetchStatus {
    case fetchingLocation
    case fetchingData
    case done
    
    var localizedString: String {
        switch self {
        case .fetchingData:
            return "Fetching the latest weather data..."
        case .fetchingLocation:
            return "Fetching your location..."
        case .done:
            return "Pull to refresh! 😍"
        }
    }
}

protocol HomeTableViewModelDelegate: class {
    func didStartFetchingData()
    func didChangeStatus(newStatus: FetchStatus)
    func didEndFetchingData()
    func didOccurError(error: NSError)
}

class HomeTableViewModel {
    let provider: Provider = DarkSkyProvider()
    var locBrain: LocationBrain?
    var latestWU: WeatherUpdate?
    var localityName: String?
    var insight = "Welcome back. Rainy is fetching your weather..."
    var storage = CodableStorage<WeatherUpdate>()
    let delegate: HomeTableViewModelDelegate
    
    init(delegate: HomeTableViewModelDelegate) {
        self.delegate = delegate
        self.locBrain = LocationBrain(delegate: self)
        self.latestWU = storage.read()
    }
    
    func startFetching() {
        self.delegate.didStartFetchingData()
        self.delegate.didChangeStatus(newStatus: .fetchingLocation)
        self.locBrain?.start()
    }
    
    /// Produces a human-readable message describing the current weather conditions.
    func generateWeatherInsight() {
        guard let wu = self.latestWU,
            let temperature = wu.currently?.temperature,
            let summary = wu.currently?.summary else {
            return
        }

        let temperatureString = self.tempToString(temp: temperature)

        if let localityName = self.localityName {
            insight = "It's \(temperatureString) and \(summary.lowercased()) in \(localityName).\n"
        } else {
            insight = "It's \(temperatureString) and \(summary.lowercased()).\n"
        }

        // The two variables here contain the precipitation amount expected
        // in the next 18 hours, and in the next 6 hours (close).
        var totalRainSum = 0.0
        var totalRainSumClose = 0.0
        var counter = 0
        while counter < 18 {
            guard let hourlyData = wu.hourly?.data?[counter] else {
                continue
            }

            totalRainSum += hourlyData.precipIntensity ?? 0.0
            counter += 1
        }
        counter = 0
        while counter < 6 {
            guard let hourlyData = wu.hourly?.data?[counter] else {
                continue
            }

            totalRainSumClose += hourlyData.precipIntensity ?? 0.0
            counter += 1
        }

        if totalRainSumClose > 0.20 {
            insight += "Rain everywhere... so depressing! 😭"
        } else if totalRainSum > 0.20 {
            insight += "Remember the umbrella. It's going to rain soon. ☹️"
        } else {
            insight += "Awesome! No rain expected any time soon. 😎"
        }
    }
    
    /**
     Returns a String with the given Double temperature.
     - Todo: this expects the API to always return a temperature
     expressed in Fahrenheit, just like DarkSky.net does. We gotta abstract
     this.
     */
    private func tempToString(temp: Double) -> String {
        switch TempUnitCoordinator.getCurrentTempUnit() {
        case .celsius:
            return String(lround(0.55555 * (temp - 32))) + "°"
        case .fahrenheit:
            return String(lround(temp)) + "°"
        }
    }
}

extension HomeTableViewModel: LocationBrainDelegate {
    func didFetchLocation(location: CLLocationCoordinate2D, name: String?) {
        self.delegate.didChangeStatus(newStatus: .fetchingData)
        NSLog("Got a location!")
        self.provider.getWeatherDataForCoordinates(coordinates: location) { result in
            switch result {
            case .success(let data):
                self.latestWU = data
                self.generateWeatherInsight()
                self.storage.save(data)
                self.delegate.didChangeStatus(newStatus: .done)
                self.delegate.didEndFetchingData()
                
            case .failure(let error):
                self.delegate.didOccurError(error: error as NSError)
                self.delegate.didEndFetchingData()
            }
        }
        localityName = name
    }
    
    func didErrorOccur(error: NSError) {
        self.delegate.didOccurError(error: error)
    }
}
