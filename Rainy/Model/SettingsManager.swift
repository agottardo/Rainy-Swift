//
//  SettingsManager.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-07.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import Foundation

/// Keys for all preferences.
enum SettingKey: String, CaseIterable {
    case temperatureUnit
    case diagnostics
}

/// Central point of entry for all settings. Add new properties by adding a new computed property
/// with its getter and setter. Update `SettingKey` above as new properties are added.
final class SettingsManager {
    static let shared: SettingsManager = .init(defaults: .standard)

    let defaults: UserDefaults

    /// Temperature unit chosen by the user.
    /// - Default: `.celsius`
    var temperatureUnit: TempUnit {
        get {
            TempUnit(rawValue: defaults.integer(forKey: SettingKey.temperatureUnit.rawValue)) ?? .celsius
        }
        set {
            defaults.set(newValue.rawValue, forKey: SettingKey.temperatureUnit.rawValue)
            defaults.synchronize()
        }
    }

    /// Whether diagnostics can be sent.
    /// - Default: `false`
    var diagnosticsEnabled: Bool {
        get {
            defaults.bool(forKey: SettingKey.diagnostics.rawValue)
        }
        set {
            defaults.set(newValue, forKey: SettingKey.diagnostics.rawValue)
            defaults.synchronize()
        }
    }

    private init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
}
