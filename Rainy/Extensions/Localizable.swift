//
//  Localizable.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-05-09.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import Foundation

protocol Localizable {
    var localizedString: String { get }
    var textLocalizedString: String? { get }
}

extension Localizable {
    var textLocalizedString: String? {
        localizedString.nilIfEmpty
    }
}
