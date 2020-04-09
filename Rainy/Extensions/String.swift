//
//  String.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-08.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import Foundation

extension String {
    var nilIfEmpty: String? {
        if isEmpty {
            return nil
        }
        return self
    }
}
