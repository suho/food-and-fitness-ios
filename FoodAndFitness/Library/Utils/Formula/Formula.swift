//
//  Formula.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/12/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import Foundation
import UIKit

enum ActiveTracking: Int {
    case walking
    case running
    case cycling

    static var count: Int {
        return self.cycling.rawValue + 1
    }

    var title: String {
        switch self {
        case .running:
            return Strings.running
        case .cycling:
            return Strings.cycling
        case .walking:
            return Strings.walking
        }
    }

    static func active(title: String) -> ActiveTracking {
        switch title {
        case self.walking.title:
            return walking
        case self.running.title:
            return running
        case self.cycling.title:
            return cycling
        default:
            return walking
        }
    }

    var image: UIImage {
        switch self {
        case .running:
            return #imageLiteral(resourceName: "img_running")
        case .cycling:
            return #imageLiteral(resourceName: "img_cycling")
        case .walking:
            return #imageLiteral(resourceName: "img_walking")
        }
    }

    var icon: UIImage {
        switch self {
        case .running:
            return #imageLiteral(resourceName: "ic_running")
        case .cycling:
            return #imageLiteral(resourceName: "ic_cycling")
        case .walking:
            return #imageLiteral(resourceName: "ic_walking")
        }
    }
}

// MARK: - BMI Calculator
func bmi(weight: Int, height: Int) -> Double {
    let result = Double(weight) * 10_000 / Double(height * height)
    return result
}

func status(bmi: Double, age: Int) -> String {
    switch age {
    default:
        switch bmi {
        case 0..<16:
            return Strings.severeThinness
        case 16..<17:
            return Strings.moderateThinness
        case 17..<18.5:
            return Strings.mildThinness
        case 18.5..<25:
            return Strings.normal
        case 25..<30:
            return Strings.overweight
        case 30..<35:
            return Strings.obeseClassI
        case 35..<40:
            return Strings.obeseClassII
        case 40..<200:
            return Strings.obeseClassIII
        default:
            return Strings.empty
        }
    }
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

// MARK: - Carbohydrates Calculator with 50%
func carbs(calories: Double) -> Int {
    let grams = calories / 8
    return Int(grams)
}

// MARK: - Protein Calculator with 20%
func protein(calories: Double) -> Int {
    let grams = calories / 20
    return Int(grams)
}

// MARK: - Fat Calculator with 30%
func fat(calories: Double) -> Int {
    let grams = calories / 27
    return Int(grams)
}

// MARK: - Met Calculator
fileprivate func met(velocity: Double, active: ActiveTracking) -> Double {
    switch active {
    case .walking:
        return metWalking(velocity: velocity)
    case .running:
        return metRunning(velocity: velocity)
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

fileprivate func metRunning(velocity: Double) -> Double {
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
func caloriesBurned(bmr: Double, velocity: Double, active: ActiveTracking, duration: Double) -> Int {
    return Int((bmr / 24) * met(velocity: velocity, active: active) * duration)
}
