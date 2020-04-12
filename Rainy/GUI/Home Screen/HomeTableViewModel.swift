//
//  HomeTableViewModel.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2019-08-18.
//  Copyright © 2019 Andrea Gottardo. All rights reserved.
//

import CoreLocation
import Foundation

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

protocol HomeTableViewModelDelegate: AnyObject {
    func didStartFetchingData()
    func didChangeStatus(newStatus: FetchStatus)
    func didEndFetchingData()
    func didOccurError(error: NSError)
}

class HomeTableViewModel {
    let provider: Provider = DarkSkyProvider()
    var latestWU: WeatherUpdate?
    var insight = "Welcome back. Rainy is fetching your weather..."
    var storage = CodableStorage<WeatherUpdate>()
    var locationsManager: LocationsManager
    let delegate: HomeTableViewModelDelegate
    var siriActivity: NSUserActivity?

    init(delegate: HomeTableViewModelDelegate,
         locationsManager: LocationsManager = .shared) {
        self.delegate = delegate
        self.locationsManager = locationsManager
        latestWU = storage.read(.weatherCache)
    }

    func startFetching() {
        delegate.didStartFetchingData()
        delegate.didChangeStatus(newStatus: .fetchingLocation)
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
                self.delegate.didChangeStatus(newStatus: .done)
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
