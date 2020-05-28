//
//  AppDelegate.swift
//  Rainy
//
//  Created by Andrea Gottardo on 10/11/17.
//  Copyright © 2017 Andrea Gottardo. All rights reserved.
//

import Sentry
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Log.initializeSentry()
        window?.tintColor = Theme.current.accentTint
        return true
    }

    /// Called when opening/restoring the app from a Siri Shortcut.
    func application(_: UIApplication, continue userActivity: NSUserActivity, restorationHandler _: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let locationsManager = LocationsManager.shared
        guard let uuidString = userActivity.userInfo?["location_uuid"] as? String,
            let uuid = UUID(uuidString: uuidString),
            let location = locationsManager.locations.first(where: { $0.uuid == uuid }) else {
            Log.error("No location with UUID.")
            return false
        }
        locationsManager.currentLocation = location
        return true
    }

    /// Constructs the UIMenu for the macOS version of the app.
    override func buildMenu(with builder: UIMenuBuilder) {
        super.buildMenu(with: builder)
        builder.remove(menu: .services)
        builder.remove(menu: .format)
        builder.remove(menu: .toolbar)
        builder.remove(menu: .edit)
        builder.remove(menu: .help)
    }
}
