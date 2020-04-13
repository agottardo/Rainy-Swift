//
//  URL.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-12.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import Foundation

extension URL {
    mutating func appendQueryParams(_ params: [String: String]) {
        var acc = ""
        var count = 0
        for (key, value) in params {
            acc += count == 0 ? "?" : "&"
            acc += "\(key)=\(value)"
            count += 1
        }
        self = URL(string: absoluteString + acc)!
    }
}
