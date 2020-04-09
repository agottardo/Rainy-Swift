//
//  HourlyTableViewCell.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-06.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import UIKit

class HourlyTableViewCell: UITableViewCell, ReusableView, NibLoadableView {
    /// Hour label.
    @IBOutlet var timeLabel: UILabel!
    /// Weather condition label.
    @IBOutlet var conditionLabel: UILabel!
    /// Temperature label.
    @IBOutlet var temperatureLabel: UILabel!
    /// Precipitation amount background layer.
    @IBOutlet var rainBox: UIView!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var rainBoxConstraint: NSLayoutConstraint!

    func configure(using data: HourCondition, timeFormatter: DateFormatter) {
        if let time = data.time {
            let hourStr = timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(time)))
            timeLabel.text = hourStr
        }

        if let temperature = data.temperature {
            temperatureLabel.text = temperature.stringRepresentation()
        }

        if let summary = data.summary {
            conditionLabel.isHidden = false
            conditionLabel.text = summary
        } else {
            conditionLabel.isHidden = true
        }

        if let icon = data.icon {
            self.icon.image = icon.icon
        }

        if let precipProbability = data.precipProbability,
            let precipIntensity = data.precipIntensity {
            rainBoxConstraint.constant = CGFloat(10 + 20 * precipProbability * 100 * precipIntensity)
        }
    }
}
