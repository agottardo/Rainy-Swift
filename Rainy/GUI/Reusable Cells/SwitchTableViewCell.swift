//
//  SwitchTableViewCell.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-05-09.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell, ReusableView, NibLoadableView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var switchOutlet: UISwitch!

    func configure(title: String,
                   description: String? = nil,
                   isOn: Bool) {
        titleLabel.text = title
        if let description = description {
            descriptionLabel.isHidden = false
            descriptionLabel.text = description
        } else {
            descriptionLabel.isHidden = true
        }
        switchOutlet.isOn = isOn
    }
}
