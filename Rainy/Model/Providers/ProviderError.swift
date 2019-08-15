//
//  ProviderError.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2018-09-03.
//  Copyright © 2018 Andrea Gottardo. All rights reserved.
//

import Foundation

/// An enum to represent errors fired by a Provider,
/// either parsing or networking errors.
enum ProviderError: Error {
    case network(networkError: NSError)
    case parsing(parsingError: NSError)
}
