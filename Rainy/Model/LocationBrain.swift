//
//  LocationBrain.swift
//  Rainy
//
//  Created by Andrea Gottardo on 10/11/17.
//  Copyright © 2017 Andrea Gottardo. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationBrain: NSObject, CLLocationManagerDelegate {

    let manager = CLLocationManager()
    var lastLocation : CLLocation?
    var callbackHome : HomeTableViewController? = nil
    
    func start() {
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.requestWhenInUseAuthorization()
            manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            manager.requestLocation()
        } else {
            callbackHome?.locationErrorOccurred()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations[0]
        callbackHome?.newLocationAvailable(location: lastLocation!)
        NSLog("Updated lastLocation.")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        callbackHome?.locationErrorOccurred()
    }
}
