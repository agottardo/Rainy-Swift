//
//  CLLocationCoordinate2D.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-08.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import CoreLocation
import Foundation

extension CLLocationCoordinate2D {
    func distance(to coordinate: CLLocationCoordinate2D) -> Double {
        let location = CLLocation(latitude: coordinate.latitude,
                                  longitude: coordinate.longitude)
        return location.distance(from: CLLocation(latitude: latitude,
                                                  longitude: longitude))
    }
}
