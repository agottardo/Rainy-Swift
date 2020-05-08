//
//  String.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-08.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import Foundation

extension String {
    /// Returns `nil` if `self` is the empty string.
    var nilIfEmpty: String? {
        if isEmpty {
            return nil
        }
        return self
    }
}
