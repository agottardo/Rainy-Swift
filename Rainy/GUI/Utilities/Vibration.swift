//
//  Vibration.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-11.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import Foundation
import UIKit

/// A wrapper around UIFeedbackGenerator subclasses.
class Vibration {
    static let notificationGenerator = UINotificationFeedbackGenerator()
    static let selectionGenerator = UISelectionFeedbackGenerator()
    static let impactGenerator = UIImpactFeedbackGenerator()

    static func success() {
        notificationGenerator.notificationOccurred(.success)
    }

    static func warning() {
        notificationGenerator.notificationOccurred(.warning)
    }

    static func error() {
        notificationGenerator.notificationOccurred(.error)
    }

    static func selectionChanged() {
        selectionGenerator.selectionChanged()
    }

    static func impactStrong() {
        impactGenerator.impactOccurred(intensity: 1.0)
    }

    static func impact() {
        impactGenerator.impactOccurred(intensity: 0.75)
    }

    static func impactLight() {
        impactGenerator.impactOccurred(intensity: 0.5)
    }
}
