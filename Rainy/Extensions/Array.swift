//
//  Array.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-06.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        if index >= count || index < 0 {
            return nil
        } else {
            return self[index]
        }
    }
}

extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
