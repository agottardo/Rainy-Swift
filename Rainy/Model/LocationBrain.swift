//
//  LocationBrain.swift
//  Rainy
//
//  Created by Andrea Gottardo on 10/11/17.
//  Copyright © 2017 Andrea Gottardo. All rights reserved.
//

import Foundation
import CoreLocation

/**
 A class that handles user location, by using the CoreLocation APIs.
 - Todo: Implement this as a singleton.
 - Todo: Replace callbackHome field with a completion handler.
 */
final class LocationBrain: NSObject, CLLocationManagerDelegate {

    let manager = CLLocationManager()
    var lastLocation: CLLocation?
    var callbackHome: HomeTableViewController?

    /**
    Sets up the CLLocationManager and asks for a location update.
    */
    func start() {
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.requestWhenInUseAuthorization()
            // Who cares about more accuracy than 1 km? Clouds are big.
            manager.desiredAccuracy = kCLLocationAccuracyKilometer
            // Ask for one location only, not more than one update.
            manager.requestLocation()
        } else {
            // If location access was not available, tell the calling view
            // controller to display an error message.
            callbackHome?.locationErrorOccurred()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations[0]
        // Inform the calling view controller that a location is available.
        callbackHome?.newLocationAvailable(location: lastLocation!)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Inform the calling view controller that something went wrong when
        // obtaining the user location.
        callbackHome?.locationErrorOccurred()
    }
}
