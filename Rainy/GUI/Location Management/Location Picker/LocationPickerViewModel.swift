//
//  LocationPickerViewModel.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-05-07.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import CoreLocation
import Foundation

final class LocationPickerViewModel {
    var geoCoder: CLGeocoder
    var locations: [Location] = []
    var locationsManager: LocationsManager

    init(locationsManager: LocationsManager = .shared) {
        geoCoder = CLGeocoder()
        self.locationsManager = locationsManager
    }

    /// Calls the geocoder to retrieve locations with the given name.
    /// - Parameters:
    ///   - placemarkKeyword: keyword to search for
    ///   - completion: completion block, returns a list of locations or an error
    func search(placemarkKeyword: String,
                completion: @escaping (Result<[Location], NSError>) -> Void) {
        geoCoder.geocodeAddressString(placemarkKeyword) { placemarks, error in
            if let error = error {
                Log.warning("CLGeocoder error: \(error)")
                completion(.failure(error as NSError))
                return
            }

            guard let placemarks = placemarks else {
                Log.debug("No placemark results found.")
                self.locations = []
                completion(.failure(NSError(domain: "No results found.", code: 1, userInfo: nil)))
                return
            }

            let locations: [Location] = placemarks.compactMap {
                guard let coordinate = $0.location?.coordinate else {
                    Log.debug("Skipping placemark \($0) with no coordinates.")
                    return nil
                }
                return Location(placemark: $0, coordinate: coordinate)
            }
            self.locations = locations
            completion(.success(locations))
        }
    }
}
