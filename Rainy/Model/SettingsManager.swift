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
    case currentLocationIndex
    case themeName
}

/// Central point of entry for all settings. Add new properties by adding a new computed property
/// with its getter and setter. Update `SettingKey` above as new properties are added.
final class SettingsManager {
    static let shared: SettingsManager = .init(defaults: .standard)

    let defaults: UserDefaults

    /// Temperature unit chosen by the user.
    /// - Default: `.celsius`
    var temperatureUnit: TemperatureUnit {
        get {
            TemperatureUnit(rawValue: defaults.integer(forKey: SettingKey.temperatureUnit.rawValue)) ?? .celsius
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

    /// Whether diagnostics can be sent.
    /// - Default: `false`
    var currentLocationIndex: Int? {
        get {
            let savedValue = defaults.integer(forKey: SettingKey.currentLocationIndex.rawValue)
            if savedValue == 0 {
                return nil
            } else {
                return savedValue - 1
            }
        }
        set {
            guard let newValue = newValue else {
                defaults.set(0, forKey: SettingKey.currentLocationIndex.rawValue)
                defaults.synchronize()
                return
            }
            defaults.set(newValue + 1, forKey: SettingKey.currentLocationIndex.rawValue)
            defaults.synchronize()
        }
    }

    var theme: Theme {
        get {
            guard let name = defaults.string(forKey: SettingKey.themeName.rawValue) else {
                return .blue
            }
            return Theme(rawValue: name) ?? .blue
        }
        set {
            defaults.set(newValue.rawValue, forKey: SettingKey.themeName.rawValue)
            defaults.synchronize()
        }
    }

    private init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
}
