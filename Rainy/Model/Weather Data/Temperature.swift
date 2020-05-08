//
//  TempUnit.swift
//  Rainy
//
//  Created by Andrea Gottardo on 14/08/2019.
//  Copyright © 2019 Andrea Gottardo. All rights reserved.
//

import Foundation

public enum TemperatureUnit: Int {
    case celsius
    case fahrenheit
}

final class Temperature: Codable {
    private let doubleValue: Double

    /// Produces a String representation of this temperature object to be displayed to the user: "22°"
    /// - Parameter settingsManager: injectable settings manager
    func stringRepresentation(settingsManager: SettingsManager = .shared) -> String {
        switch settingsManager.temperatureUnit {
        case .celsius:
            return String(lround(0.55555 * (doubleValue - 32))) + "°"
        case .fahrenheit:
            return String(lround(doubleValue)) + "°"
        }
    }

    /// Creates a temperature object from a Fahrenheit temperature value.
    init(fromFahrenheit fahrenheitValue: Double) {
        doubleValue = fahrenheitValue
    }

    required init(from: Decoder) {
        do {
            let container = try from.singleValueContainer()
            doubleValue = try container.decode(Double.self)
        } catch {
            Log.error("Failed to parse temperature, not a double.")
            doubleValue = 0
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(doubleValue)
    }
}
