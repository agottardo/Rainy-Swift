//
//  LocationBrain.swift
//  Rainy
//
//  Created by Andrea Gottardo on 10/11/17.
//  Copyright © 2017 Andrea Gottardo. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationBrainDelegate: class {
    func didFetchLocation(location: CLLocationCoordinate2D)
    func didErrorOccur(error: NSError)
}

/**
 A class that handles user location, by using the CoreLocation APIs.
 - Todo: Implement this as a singleton.
 - Todo: Replace callbackHome field with a completion handler.
 */
final class LocationBrain: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var lastLocation: CLLocation?
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
            self.delegate?.didErrorOccur(error: NSError(domain: "location",
                                                        code: -1,
                                                        userInfo: [
                NSLocalizedDescriptionKey: "Location Services were not authorized."
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
        self.lastLocation = lastLocation
        // Inform the calling view controller that a location is available.
        self.delegate?.didFetchLocation(location: lastLocation.coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Inform the calling view controller that something went wrong when
        // obtaining the user location.
        self.delegate?.didErrorOccur(error: error as NSError)
    }
}
