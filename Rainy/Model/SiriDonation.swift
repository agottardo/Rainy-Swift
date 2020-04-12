//
//  SiriDonation.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-11.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import Foundation

class SiriDonation {
    enum Action: Hashable {
        case getWeather(location: Location)

        func hash(into hasher: inout Hasher) {
            switch self {
            case let .getWeather(location):
                hasher.combine(location.uuid)
            }
        }

        var userActivity: NSUserActivity {
            let activity = NSUserActivity(activityType: String(hashValue))
            switch self {
            case let .getWeather(location):
                Log.debug("Constructing userActivity for location: \(location.displayName)")
                activity.keywords.insert(location.displayName)
                activity.keywords.insert(location.subtitle)
                activity.suggestedInvocationPhrase = "Weather for \(location.displayName)"
                activity.title = "Weather for \(location.displayName)"
                activity.userInfo = ["location_uuid": location.uuid.uuidString]
            }
            activity.keywords = ["weather", "rainy"]
            activity.isEligibleForHandoff = false
            activity.isEligibleForPublicIndexing = true
            activity.isEligibleForSearch = true
            activity.isEligibleForPrediction = true
            return activity
        }
    }
}