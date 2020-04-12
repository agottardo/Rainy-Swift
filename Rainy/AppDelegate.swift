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
        do {
            Client.shared = try Client(dsn: "https://6940618716d54c108188e82ba381383a@o304136.ingest.sentry.io/5193012")
            Client.shared?.enabled = SettingsManager.shared.diagnosticsEnabled as NSNumber
            try Client.shared?.startCrashHandler()
        } catch {
            print("\(error)")
        }
        window?.tintColor = Theme.current.accentTint
        return true
    }

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
}
