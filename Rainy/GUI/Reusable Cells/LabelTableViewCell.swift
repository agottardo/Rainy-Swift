//
//  LabelTableViewCell.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-05-09.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import UIKit

class LabelTableViewCell: UITableViewCell, ReusableView, NibLoadableView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    func configure(title: String, description: String? = nil) {
        titleLabel.text = title
        if let description = description {
            descriptionLabel.text = description
            descriptionLabel.isHidden = false
        } else {
            descriptionLabel.isHidden = true
        }
    }
}
