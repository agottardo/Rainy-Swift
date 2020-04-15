//
//  HomeTableViewModel.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2019-08-18.
//  Copyright © 2019 Andrea Gottardo. All rights reserved.
//

import CoreLocation
import Foundation

protocol HomeTableViewModelDelegate: AnyObject {
    func didStartFetchingData()
    func didEndFetchingData()
    func didOccurError(error: NSError)
}

class HomeTableViewModel {
    /// Represents a kind of row displayed in the home screen.
    enum Row {
        /// Used for weather alerts.
        case alert(alert: WeatherAlert)
        /// Contains a 4-days forecast.
        case fourDays(dailyConditions: [DailyCondition])
        /// Header representing the day in hourly forecasts.
        case dayHeader
        /// Shows an hourly forecast.
        case hourly(condition: HourCondition)
    }

    var visibleRows: [Row] {
        guard locationsManager.currentLocation != nil else {
            return []
        }

        var acc = [Row]()

        for alert in latestWU?.alerts ?? [] {
            acc.append(.alert(alert: alert))
        }

        if let dailyConditions = latestWU?.daily?.data {
            acc.append(.fourDays(dailyConditions: dailyConditions))
        }

        acc += latestWU?.hourly?.data?.compactMap { Row.hourly(condition: $0) } ?? []

        return acc
    }

    let provider: Provider = DarkSkyProvider()
    private var latestWU: WeatherUpdate?
    var storage = CodableStorage<WeatherUpdate>()
    var locationsManager: LocationsManager
    let delegate: HomeTableViewModelDelegate
    private var siriActivity: NSUserActivity?

    init(delegate: HomeTableViewModelDelegate,
         locationsManager: LocationsManager = .shared) {
        self.delegate = delegate
        self.locationsManager = locationsManager
        latestWU = storage.read(.weatherCache)
    }

    func startFetching() {
        delegate.didStartFetchingData()
        guard let currentLocation = locationsManager.currentLocation else {
            // TODO: handle no current location saved.
            return
        }
        siriActivity = SiriDonation.Action.getWeather(location: currentLocation).userActivity
        provider.getWeatherDataForCoordinates(coordinates: currentLocation.coordinate) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                self.latestWU = data
                self.storage.save(.weatherCache, codable: data)
                self.delegate.didEndFetchingData()
                self.siriActivity?.becomeCurrent()

            case let .failure(error):
                self.delegate.didOccurError(error: error as NSError)
                self.delegate.didEndFetchingData()
            }
        }
    }
}

extension HomeTableViewModel {
    func didErrorOccur(error: NSError) {
        delegate.didOccurError(error: error)
    }
}
