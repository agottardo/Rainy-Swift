//
//  CurrentInfoTableViewCell.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-06.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import UIKit

class CurrentInfoTableViewCell: UITableViewCell, ReusableView, NibLoadableView {
    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var longTextLabel: UILabel!

    func configure(with data: WeatherUpdate?, localityName _: String?) {
        guard let data = data else {
            longTextLabel.text = "Loading data, please wait."
            temperatureLabel.text = nil
            weatherIcon.image = nil
            return
        }
        guard let temperature = data.currently?.temperature,
            let summary = data.currently?.summary else {
            return
        }

        var insight: String = "It's \(summary.lowercased()).\n"

        // The two variables here contain the precipitation amount expected
        // in the next 18 hours, and in the next 6 hours (close).
        var totalRainSum = 0.0
        var totalRainSumClose = 0.0
        var counter = 0
        while counter < 18 {
            guard let hourlyData = data.hourly?.data?[counter] else {
                continue
            }

            totalRainSum += hourlyData.precipIntensity ?? 0.0
            counter += 1
        }
        counter = 0
        while counter < 6 {
            guard let hourlyData = data.hourly?.data?[counter] else {
                continue
            }

            totalRainSumClose += hourlyData.precipIntensity ?? 0.0
            counter += 1
        }

        if totalRainSumClose > 0.20 {
            insight += "Rain everywhere... so depressing! 😭"
        } else if totalRainSum > 0.20 {
            insight += "Remember the umbrella. It's going to rain soon. ☹️"
        } else {
            insight += "No rain expected any time soon. 😎"
        }

        longTextLabel.text = insight
        temperatureLabel.text = temperature.stringRepresentation()
        weatherIcon.image = data.currently?.icon?.icon
    }
}
