//
//  ThemePickerTableViewCell.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-11.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import UIKit

class ThemePickerTableViewCell: UITableViewCell, ReusableView, NibLoadableView {
    @IBOutlet var themeNameLabel: UILabel!
    @IBOutlet var themeColorBox: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        themeColorBox.layer.cornerRadius = 10
    }

    func configure(with theme: Theme) {
        themeColorBox.backgroundColor = theme.accentTint
        themeNameLabel.text = theme.localizedString

        if theme == Theme.current {
            accessoryType = .checkmark
        } else {
            accessoryType = .none
        }
    }
}
