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

    override func awakeFromNib() {
        super.awakeFromNib()
        rainBox.backgroundColor = Theme.current.accentTint.withAlphaComponent(0.4)
        temperatureLabel.textColor = Theme.current.accentTint
    }

    func configure(using data: HourCondition,
                   previous: HourCondition?,
                   timeFormatter: DateFormatter) {
        if let time = data.time {
            let hourStr = timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(time)))
            timeLabel.text = hourStr
        }

        if let temperature = data.temperature {
            temperatureLabel.text = temperature.stringRepresentation()
        }

        if let icon = data.icon {
            self.icon.image = icon.icon
        }

        if let summary = data.summary {
            conditionLabel.text = summary
            if previous?.summary != summary {
                conditionLabel.textColor = .label
                icon.tintColor = .label
            } else {
                conditionLabel.textColor = .tertiaryLabel
                icon.tintColor = .tertiaryLabel
            }
        } else {
            conditionLabel.text = nil
        }

        if let precipProbability = data.precipProbability,
            let precipIntensity = data.precipIntensity {
            rainBoxConstraint.constant = CGFloat(10 + 20 * precipProbability * 100 * precipIntensity)
        }
    }
}
