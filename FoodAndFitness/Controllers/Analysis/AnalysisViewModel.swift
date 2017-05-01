//
//  AnalysisViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/30/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import RealmS
import RealmSwift
import SwiftDate

class AnalysisViewModel {

    private var eatenCalories: [Int] = [Int]()
    private var burnedCalories: [Int] = [Int]()
    private var proteins: [Int] = [Int]()
    private var carbs: [Int] = [Int]()
    private var fat: [Int] = [Int]()

    init() {
        let now = DateInRegion(absoluteDate: Date())
        for i in 0..<7 {
            let date = now - (7 - i).days
            let eaten = AnalysisViewModel.nutritionValue(at: date.absoluteDate, type: .calories)
            let burned = AnalysisViewModel.burnedCalories(at: date.absoluteDate)
            let protein = AnalysisViewModel.nutritionValue(at: date.absoluteDate, type: .protein)
            let carbs = AnalysisViewModel.nutritionValue(at: date.absoluteDate, type: .carbs)
            let fat = AnalysisViewModel.nutritionValue(at: date.absoluteDate, type: .fat)
            self.eatenCalories.append(eaten)
            self.burnedCalories.append(burned)
            self.proteins.append(protein)
            self.carbs.append(carbs)
            self.fat.append(fat)
        }
    }

    func dataForChartView() -> ChartViewCell.Data {
        return ChartViewCell.Data(eatenCalories: eatenCalories, burnedCalories: burnedCalories)
    }

    private enum FoodNutritionType {
        case calories
        case protein
        case carbs
        case fat
    }

    private class func nutritionValue(at date: Date, type: FoodNutritionType) -> Int {
        let userFoods = RealmS().objects(UserFood.self).filter { (userFood) -> Bool in
            guard let me = User.me, let user = userFood.userHistory?.user else { return false }
            return me.id == user.id && userFood.createdAt.isInSameDayOf(date: date)
        }
        let value = userFoods.map { (userFood) -> Int in
            switch type {
            case .calories:
                return userFood.calories
            case .protein:
                return userFood.protein
            case .carbs:
                return userFood.carbs
            case .fat:
                return userFood.fat
            }
        }.reduce(0) { (result, protein) -> Int in
            return result + protein
        }
        return value
    }

    private class func burnedCalories(at date: Date) -> Int {
        let userExercises = RealmS().objects(UserExercise.self).filter { (userExercise) -> Bool in
            guard let me = User.me, let user = userExercise.userHistory?.user else { return false }
            return me.id == user.id && userExercise.createdAt.isInSameDayOf(date: date)
        }
        let exercisesBurn = userExercises.map { (userExercise) -> Int in
            return userExercise.calories
        }.reduce(0) { (result, calories) -> Int in
            return result + calories
        }
        let trackings = RealmS().objects(Tracking.self).filter { (tracking) -> Bool in
            guard let me = User.me, let user = tracking.userHistory?.user else { return false }
            return me.id == user.id && tracking.createdAt.isInSameDayOf(date: date)
        }
        let trackingsBurn = trackings.map { (tracking) -> Int in
            return tracking.caloriesBurn
        }.reduce(0) { (result, calories) -> Int in
            return result + calories
        }
        return exercisesBurn + trackingsBurn
    }
}
