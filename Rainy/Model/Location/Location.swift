//
//  Location.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-08.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import CoreLocation
import Foundation

struct Location: Codable {
    let uuid: UUID
    let displayName: String
    let subtitle: String

    private let latitude: Double
    private let longitude: Double

    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(placemark: CLPlacemark, coordinate: CLLocationCoordinate2D) {
        latitude = coordinate.latitude
        longitude = coordinate.longitude
        let availableFields = [
            placemark.name,
            placemark.subThoroughfare,
            placemark.thoroughfare,
            placemark.subLocality,
            placemark.locality,
            placemark.subAdministrativeArea,
            placemark.administrativeArea,
            placemark.postalCode,
            placemark.country,
        ].compactMap { $0 }.uniques
        displayName = availableFields.first ?? placemark.description
        subtitle = availableFields.dropFirst().joined(separator: ", ")
        uuid = UUID()
    }
}
