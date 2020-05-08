//
//  LocationBrain.swift
//  Rainy
//
//  Created by Andrea Gottardo on 10/11/17.
//  Copyright © 2017 Andrea Gottardo. All rights reserved.
//

import CoreLocation
import Foundation

protocol LocationBrainDelegate: AnyObject {
    func didFetchLocation(location: Location)
    func didErrorOccur(error: NSError)
}

/**
 A class that handles user location, by using the CoreLocation APIs.
 */
final class LocationBrain: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var lastLocation: Location?
    weak var delegate: LocationBrainDelegate?

    init(delegate: LocationBrainDelegate) {
        self.delegate = delegate
    }

    /**
     Sets up the CLLocationManager and asks for a location update.
     */
    func start() {
        guard CLLocationManager.locationServicesEnabled() else {
            // If location access was not available, tell the calling view
            // controller to display an error message.
            delegate?.didErrorOccur(error: NSError(domain: "location",
                                                   code: -1,
                                                   userInfo: [
                                                       NSLocalizedDescriptionKey: "Location Services were not authorized.",
                                                   ]))
            return
        }
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        // Who cares about more accuracy than 3 km? Clouds are big.
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        // Ask for one location only, not more than one update.
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.count > 0,
            let lastLocation = locations.first else {
            return
        }
        manager.stopUpdatingLocation()

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(lastLocation) { placemarks, error in
            // Inform the calling view controller that a location is available.
            if let error = error {
                self.delegate?.didErrorOccur(error: error as NSError)
                return
            }
            guard let placemark = placemarks?.first else {
                Log.error("No placemark found.")
                return
            }
            let location = Location(placemark: placemark, coordinate: lastLocation.coordinate)
            self.delegate?.didFetchLocation(location: location)
        }
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        // Inform the calling view controller that something went wrong when
        // obtaining the user location.
        delegate?.didErrorOccur(error: error as NSError)
    }
}
