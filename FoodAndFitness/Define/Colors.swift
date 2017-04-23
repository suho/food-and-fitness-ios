//
//  Colors.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/7/16.
//  Copyright © 2016 SuHoVan. All rights reserved.
//

import SwiftUtils

// MARK: - Base
final class Color {
    static let white = UIColor.white
    static let lightBeige = UIColor.RGB(243, 237, 216)
    static let blue63 = UIColor.RGB(63, 166, 232)
    static let gray245 = UIColor.RGB(245, 245, 245)
    static let blackAlpha20 = UIColor.RGB(0, 0, 0, 0.2)
    static var random: UIColor {
        let r = Int(arc4random_uniform(255))
        let g = Int(arc4random_uniform(255))
        let b = Int(arc4random_uniform(255))
        return UIColor.RGB(r, g, b)
    }
}
