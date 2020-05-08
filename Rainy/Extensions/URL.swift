//
//  URL.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-12.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import Foundation

extension URL {
    /// Appends the given key-value pairs to this URL as GET request parameters.
    /// - Parameter params: key-value pairs
    mutating func appendQueryParams(_ params: [String: String]) {
        var acc = ""
        var count = 0
        for (key, value) in params {
            acc += count == 0 ? "?" : "&"
            acc += "\(key)=\(value)"
            count += 1
        }
        guard let newURL = URL(string: absoluteString + acc) else {
            Log.warning("Could not create new URL from parameters!")
            return
        }
        self = newURL
    }
}
