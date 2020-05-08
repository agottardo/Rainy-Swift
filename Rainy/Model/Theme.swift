//
//  Theme.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-11.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import Foundation
import UIKit

enum Theme: String, CaseIterable {
    case blue
    case green
    case red
    case orange
    case pink
    case purple
    case indigo
    case gray

    static var current: Theme {
        get {
            SettingsManager.shared.theme
        }
        set {
            SettingsManager.shared.theme = newValue
            UIApplication.shared.windows.first?.tintColor = newValue.accentTint
            NotificationCenter.default.post(name: NotificationName.themeDidChange.name,
                                            object: nil, userInfo: nil)
        }
    }

    var localizedString: String {
        switch self {
        case .blue:
            return "Blue"
        case .green:
            return "Green"
        case .red:
            return "Red"
        case .orange:
            return "Orange"
        case .indigo:
            return "Indigo"
        case .pink:
            return "Pink"
        case .purple:
            return "Purple"
        case .gray:
            return "Gray"
        }
    }

    var accentTint: UIColor {
        switch self {
        case .blue:
            return .systemBlue
        case .green:
            return .systemGreen
        case .red:
            return .systemRed
        case .orange:
            return .systemOrange
        case .indigo:
            return .systemIndigo
        case .pink:
            return .systemPink
        case .purple:
            return .systemPurple
        case .gray:
            return .systemGray
        }
    }
}
