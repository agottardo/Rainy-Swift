//
//  DateTableViewCell.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2018-08-16.
//  Copyright © 2018 Andrea Gottardo. All rights reserved.
//

import Foundation
import UIKit

class DateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
