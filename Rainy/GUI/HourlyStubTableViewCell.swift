//
//  HourlyStubTableViewCell.swift
//  Rainy
//
//  Created by Andrea Gottardo on 10/11/17.
//  Copyright © 2017 Andrea Gottardo. All rights reserved.
//

import UIKit

/**
 A cell containing weather information for an hour,
 derived from an HourlyStub.
 */
class HourlyStubTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var rainBox: UIView!
}
