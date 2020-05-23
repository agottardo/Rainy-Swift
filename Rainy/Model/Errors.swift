//
//  Errors.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-05-23.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import Foundation
import UIKit

enum RainyError: LocalizedError {
    // - MARK: Location management
    case locationServicesDisabled
    case locationServicesDenied
    case locationServicesCustom(error: NSError)
    case geocoderError

    // - MARK: Push notifications
    case couldNotRegisterForPushNotifications
    case systemNotificationsDisabled

    var localizedDescription: String {
        switch self {
        case .locationServicesDisabled:
            return "Sorry, Location Services are disabled on this device. Please enable them in the Settings."
        case .locationServicesDenied:
            return "Sorry, you denied Rainy access to Location Services. Please enable them in the Settings."
        case let .locationServicesCustom(error):
            return "Sorry, but I could not fetch your location. The device returned this error: \(error.localizedDescription)"
        case .geocoderError:
            return "Yikes. I was able to fetch your location, but the Apple geocoder could not find any placename at your coordinates. Please try searching for your location manually."
        case .couldNotRegisterForPushNotifications:
            return "Could not register for push notifications. Please check your Internet connection."
        case .systemNotificationsDisabled:
            return "Notifications for Rainy are disabled in the System Settings app. Please enable them there, otherwise Rainy won't be able to deliver them to you."
        }
    }
}

extension UIAlertController {
    convenience init(error: RainyError) {
        self.init(title: "An error occurred.",
                  message: error.localizedDescription,
                  preferredStyle: .alert)
        addAction(.init(title: "Dismiss", style: .cancel, handler: nil))
    }

    static func present(withError error: RainyError, inController controller: UIViewController) {
        let alertController = UIAlertController(error: error)
        controller.present(alertController, animated: true, completion: nil)
    }
}
