//
//  CurrentInfoTableViewCell.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-06.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import UIKit

/// Cell that shows five days of daily forecasts, used at the top of the home screen.
class FiveDaysTableViewCell: UITableViewCell, ReusableView, NibLoadableView {
    @IBOutlet var stackView: UIStackView!

    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "EEE"
        return formatter
    }()

    func configure(with dailyConditions: [DailyCondition], location _: Location?) {
        backgroundColor = Theme.current.accentTint
        stackView.distribution = .fillEqually
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        var count = 0
        for day in dailyConditions {
            if count > 4 {
                break
            }
            guard let timestamp = day.time else { continue }
            let dayString = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
            let titleLabel = UILabel()
            titleLabel.textColor = .white
            titleLabel.text = dayString.uppercased()
            titleLabel.textAlignment = .center
            titleLabel.font = .systemFont(ofSize: 13.0, weight: .semibold)
            let iconView = UIImageView(image: day.icon?.icon)
            iconView.tintColor = .white
            let temperatureHighLabel = UILabel()
            temperatureHighLabel.textColor = .white
            temperatureHighLabel.text = day.temperatureHigh?.stringRepresentation()
            temperatureHighLabel.textAlignment = .center
            temperatureHighLabel.font = .systemFont(ofSize: 13.0, weight: .semibold)
            let temperatureLowLabel = UILabel()
            temperatureLowLabel.textColor = .white
            temperatureLowLabel.text = day.temperatureLow?.stringRepresentation()
            temperatureLowLabel.textAlignment = .center
            temperatureLowLabel.font = .systemFont(ofSize: 12.0, weight: .regular)
            let dayStackView = UIStackView(arrangedSubviews: [
                titleLabel,
                iconView,
                temperatureHighLabel,
                temperatureLowLabel,
            ])
            dayStackView.axis = .vertical
            dayStackView.spacing = 2
            dayStackView.alignment = .center
            stackView.addArrangedSubview(dayStackView)
            count += 1
        }
    }
}
