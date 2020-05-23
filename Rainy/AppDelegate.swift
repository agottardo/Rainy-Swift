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
        // Register the app with Sentry.
        do {
            Client.shared = try Client(dsn: "https://6940618716d54c108188e82ba381383a@o304136.ingest.sentry.io/5193012")
            // This feature is strictly opt-in to preserve user privacy, so we check whether
            // the user enabled it and disable the library if the setting value is zero.
            Client.shared?.enabled = SettingsManager.shared.diagnosticsEnabled as NSNumber
            try Client.shared?.startCrashHandler()
        } catch {
            // Sentry is not yet initialized here, so we cannot use the `Log`.
            print("\(error)")
        }
        window?.tintColor = Theme.current.accentTint
        UNUserNotificationCenter.current().delegate = self
        UIApplication.shared.registerForRemoteNotifications()
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

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Log.debug("Registered for notifications with token: \(deviceToken), will contact server")
        let urlSession = URLSession(configuration: .ephemeral)
        let requestURL = URL(string: "http://192.168.1.40:8080/register")!
        var urlRequest = URLRequest(url: requestURL,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: 10.0)
        urlRequest.httpBody = deviceToken
        urlRequest.httpMethod = "POST"

        let task = urlSession.dataTask(with: urlRequest) { _, _, error in
            if let error = error {
                // Networking error
                Log.warning("Failed to subscribe to notifications with backend: \(error)")
                return
            }
        }
        // Start the HTTP request.
        task.resume()
    }

    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Log.error(error.localizedDescription)
    }

    func application(_: UIApplication, didFailToContinueUserActivityWithType _: String, error: Error) {
        Log.error(error.localizedDescription)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_: UNUserNotificationCenter, willPresent _: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }

    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler _: @escaping () -> Void) {
        Log.debug("Notification action: \(response)")
    }
}
