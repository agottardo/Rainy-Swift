//
//  TempUnit.swift
//  Rainy
//
//  Created by Andrea Gottardo on 14/08/2019.
//  Copyright © 2019 Andrea Gottardo. All rights reserved.
//

import Foundation

enum TempUnit: Int {
    case celsius
    case fahrenheit
}

class TempUnitCoordinator {
    static func getCurrentTempUnit() -> TempUnit {
        if UserDefaults.standard.bool(forKey: "fahren") {
            return .fahrenheit
        } else {
            return .celsius
        }
    }
    
    static func setCurrentTempUnit(newValue: TempUnit) {
        switch newValue {
        case .celsius:
            UserDefaults.standard.set(false, forKey: "fahren")
        case .fahrenheit:
            UserDefaults.standard.set(true, forKey: "fahren")
        }
        UserDefaults.standard.synchronize()
    }
}
