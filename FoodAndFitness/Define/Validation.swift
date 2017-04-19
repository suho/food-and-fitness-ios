//
//  Validation.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/11/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import Foundation

enum Validation {
    case success
    case failure(String)

    static let maxInput = 250
    static let minHeightInput = 50
    static let minWeightInput = 10
    static let minPasswordInput = 8
    static let maxPasswordInput = 32
}
