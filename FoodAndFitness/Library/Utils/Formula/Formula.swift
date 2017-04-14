//
//  Formula.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/12/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import Foundation

enum Activities {
    case walking
    case jogging
    case cycling
}

// MARK: - BMI Calculator
func bmi(weight: Int, height: Int) -> Double {
    let result = Double(weight) * 10_000 / Double(height * height)
    return result
}

// MARK: - BMR Calculator
func bmr(weight: Int, height: Int, age: Int, gender: Gender) -> Double {
    let value = 10 * Double(weight) + 6.25 * Double(height) - 5 * Double(age)
    switch gender {
    case .male:
        return value + 5
    case .female:
        return value - 161
    case .others: return 0
    }
}

// MARK: - Carbohydrates Calculator
func carbs(calories: Double) -> Int {
    let grams = calories / 4
    return Int(grams)
}

// MARK: - Protein Calculator
func protein(calories: Double) -> Int {
    return carbs(calories: calories)
}

// MARK: - Fat Calculator
func fat(calories: Double) -> Int {
    let grams = calories / 9
    return Int(grams)
}

// MARK: - Met Calculator
func met(velocity: Double, active: Activities) -> Double {
    switch active {
    case .walking:
        return metWalking(velocity: velocity)
    case .jogging:
        return metJogging(velocity: velocity)
    case .cycling:
        return metCycling(velocity: velocity)
    }
}

fileprivate func metWalking(velocity: Double) -> Double {
    switch velocity {
    case 0..<3.2:
        return 2.0
    case 3.2..<4:
        return 2.8
    case 4..<4.5:
        return 3.0
    case 4.5..<5.2:
        return 3.5
    case 5.2..<5.6:
        return 4.3
    case 5.6..<6.4:
        return 5.0
    case 6.4..<7.2:
        return 7.0
    case 7.2..<20:
        return 8.3
    default: return 0
    }
}

fileprivate func metJogging(velocity: Double) -> Double {
    switch velocity {
    case 0..<6.4:
        return 6
    case 6.4..<8:
        return 8.3
    case 8..<9.5:
        return 9.8
    case 9.5..<11.3:
        return 11.0
    case 11.3..<12:
        return 11.8
    case 12..<14.5:
        return 12.8
    case 14.5..<16:
        return 14.5
    case 16..<17.7:
        return 16
    case 17.7..<19.3:
        return 19.0
    case 19.3..<20.9:
        return 19.8
    case 20.9..<50:
        return 23.0
    default: return 0
    }
}

fileprivate func metCycling(velocity: Double) -> Double {
    switch velocity {
    case 0..<8.9:
        return 3.5
    case 8.9..<16:
        return 4.0
    case 16..<19.2:
        return 6.8
    case 19.2..<22.4:
        return 8.0
    case 22.4..<25.6:
        return 10.0
    case 25.6..<32.2:
        return 12.0
    case 32.2..<100:
        return 15.8
    default: return 0
    }
}

// MARK: - Calories Burn Calculator
func caloriesBurned(bmr: Double, met: Double, duration: Double) -> Int {
    return Int((bmr / 24) * met * duration)
}
