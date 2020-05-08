//
//  Vibration.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-11.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import Foundation
import UIKit

/// A wrapper around UIFeedbackGenerator subclasses so we don't have to deal with multiple objects
/// thanks to static methods.
class Vibration {
    /// The intensity of a impact feedback.
    enum Intensity: CGFloat {
        case light = 0.5
        case medium = 0.75
        case strong = 1
    }

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

    static func impact(_ intensity: Intensity) {
        impactGenerator.impactOccurred(intensity: intensity.rawValue)
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
