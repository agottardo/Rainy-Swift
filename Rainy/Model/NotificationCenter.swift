//
//  NotificationCenter.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-11.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import Foundation

enum NotificationName: String {
    case currentLocationDidChange
    case themeDidChange

    var name: Notification.Name {
        .init(rawValue: rawValue)
    }
}
