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
    var locBrain: LocationBrain?
    var latestWU: WeatherUpdate?
    var localityName: String?
    var insight = "Welcome back. Rainy is fetching your weather..."
    var storage = CodableStorage<WeatherUpdate>()
    let delegate: HomeTableViewModelDelegate

    init(delegate: HomeTableViewModelDelegate) {
        self.delegate = delegate
        locBrain = LocationBrain(delegate: self)
        latestWU = storage.read()
    }

    func startFetching() {
        delegate.didStartFetchingData()
        delegate.didChangeStatus(newStatus: .fetchingLocation)
        locBrain?.start()
    }
}

extension HomeTableViewModel: LocationBrainDelegate {
    func didFetchLocation(location: CLLocationCoordinate2D, name: String?) {
        delegate.didChangeStatus(newStatus: .fetchingData)
        Log.debug("Received a location.")
        provider.getWeatherDataForCoordinates(coordinates: location) { result in
            switch result {
            case let .success(data):
                self.latestWU = data
                self.storage.save(data)
                self.delegate.didChangeStatus(newStatus: .done)
                self.delegate.didEndFetchingData()

            case let .failure(error):
                self.delegate.didOccurError(error: error as NSError)
                self.delegate.didEndFetchingData()
            }
        }
        localityName = name
    }

    func didErrorOccur(error: NSError) {
        delegate.didOccurError(error: error)
    }
}
