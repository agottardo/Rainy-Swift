//
//  LocationTableViewCell.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-08.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import CoreLocation
import UIKit

class LocationTableViewCell: UITableViewCell, NibLoadableView, ReusableView {
    struct Constants {
        static let vancouver = CLLocationCoordinate2D(latitude: 49.246292,
                                                      longitude: -123.116226)
    }

    lazy var lengthFormatter: LengthFormatter = {
        let formatter = LengthFormatter()
        formatter.isForPersonHeightUse = false
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.numberFormatter.usesGroupingSeparator = false
        return formatter
    }()

    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var compassIcon: UIImageView!

    func configure(for location: Location) {
        let distance = location.coordinate.distance(to: Constants.vancouver)
        let distanceString = lengthFormatter.string(fromMeters: distance)
        mainLabel.text = location.displayName
        subtitleLabel.text = location.subtitle
        distanceLabel.text = distanceString
    }
}
