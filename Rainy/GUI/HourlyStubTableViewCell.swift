//
//  HourlyStubTableViewCell.swift
//  Rainy
//
//  Created by Andrea Gottardo on 10/11/17.
//  Copyright © 2017 Andrea Gottardo. All rights reserved.
//

import UIKit

/**
 A UITableViewCell containing weather information for an hour,
 data displayed comes from an HourlyStub.
 */
class HourlyStubTableViewCell: UITableViewCell {
    /// Hour label.
    @IBOutlet var timeLabel: UILabel!
    /// Weather condition label.
    @IBOutlet var conditionLabel: UILabel!
    /// Temperature label.
    @IBOutlet var temperatureLabel: UILabel!
    /// Precipitation amount background layer.
    @IBOutlet var rainBox: UIView!
}
