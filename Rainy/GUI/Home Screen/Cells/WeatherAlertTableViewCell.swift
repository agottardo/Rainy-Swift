//
//  WeatherAlertTableViewCell.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-14.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import UIKit

class WeatherAlertTableViewCell: UITableViewCell, ReusableView, NibLoadableView {
    @IBOutlet var severityIcon: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var severityLabel: UILabel!

    func configure(with alert: WeatherAlert) {
        backgroundColor = alert.severity.color
        titleLabel.text = alert.severity.localizedString + " in effect"
        severityIcon.image = alert.severity.icon
    }
}
