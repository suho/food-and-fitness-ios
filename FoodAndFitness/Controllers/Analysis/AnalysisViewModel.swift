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

fileprivate enum FoodNutritionType {
    case calories
    case protein
    case carbs
    case fat
}

fileprivate enum ExerciseType {
    case calories
    case duration
}

fileprivate enum TrackingType {
    case calories
    case duration
    case distance
}

class AnalysisViewModel {

    private var eatenCalories: [Int] = [Int]()
    private var burnedCalories: [Int] = [Int]()
    private var proteins: [Int] = [Int]()
    private var carbs: [Int] = [Int]()
    private var fat: [Int] = [Int]()
    private var durations: [Int] = [Int]()
    private var distances: [Int] = [Int]()

    init() {
        let now = DateInRegion(absoluteDate: Date())
        for i in 0..<7 {
            let date = now - (7 - i).days
            let eaten = AnalysisViewModel.nutritionValue(at: date.absoluteDate, type: .calories)
            let burned = AnalysisViewModel.burnedCalories(at: date.absoluteDate)
            let protein = AnalysisViewModel.nutritionValue(at: date.absoluteDate, type: .protein)
            let carbs = AnalysisViewModel.nutritionValue(at: date.absoluteDate, type: .carbs)
            let fat = AnalysisViewModel.nutritionValue(at: date.absoluteDate, type: .fat)
            let durationsValue = AnalysisViewModel.durationFitness(at: date.absoluteDate)
            let distancesValue = AnalysisViewModel.distanceFitness(at: date.absoluteDate)
            self.eatenCalories.append(eaten)
            self.burnedCalories.append(burned)
            self.proteins.append(protein)
            self.carbs.append(carbs)
            self.fat.append(fat)
            self.durations.append(durationsValue)
            self.distances.append(distancesValue)
        }
    }

    func dataForChartView() -> ChartViewCell.Data {
        return ChartViewCell.Data(eatenCalories: eatenCalories, burnedCalories: burnedCalories)
    }

    func dataForFitnessCell() -> AnalysisFitnessCell.Data? {
        let caloriesBurnSum = burnedCalories.reduce(0) { (result, value) -> Int in
            return result + value
        }
        let calories = "\(caloriesBurnSum)\(Strings.kilocalories)"
        let durationsSum = durations.reduce(0) { (result, value) -> Int in
            return result + value
        }
        let minutes = durationsSum.toMinutes
        var duration = ""
        if minutes < 1 {
            duration = "\(durationsSum)\(Strings.seconds)"
        } else {
            duration = "\(minutes)\(Strings.minute)"
        }
        let distanceSum = distances.reduce(0) { (result, value) -> Int in
            return result + value
        }
        let distance = "\(distanceSum)\(Strings.metters)"
        return AnalysisFitnessCell.Data(calories: calories, duration: duration, distance: distance)
    }

    func dataForNutritionCell() -> AnalysisNutritionCell.Data? {
        let caloriesSum = eatenCalories.reduce(0) { (result, value) -> Int in
            return result + value
        }
        let calories = "\(caloriesSum)\(Strings.kilocalories)"
        let proteinSum = proteins.reduce(0) { (result, value) -> Int in
            return result + value
        }
        let protein = "\(proteinSum)\(Strings.gam)"

        let carbsSum = self.carbs.reduce(0) { (result, value) -> Int in
            return result + value
        }
        let carbs = "\(carbsSum)\(Strings.gam)"

        let fatSum = self.fat.reduce(0) { (result, value) -> Int in
            return result + value
        }
        let fat = "\(fatSum)\(Strings.gam)"

        return AnalysisNutritionCell.Data(calories: calories, protein: protein, carbs: carbs, fat: fat)
    }

    private class func exerciseValue(at date: Date, type: ExerciseType) -> Int {
        let userExercises = RealmS().objects(UserExercise.self).filter { (userExercise) -> Bool in
            guard let me = User.me, let user = userExercise.userHistory?.user else { return false }
            return me.id == user.id && userExercise.createdAt.isInSameDayOf(date: date)
        }
        let value = userExercises.map { (userExercise) -> Int in
            switch type {
            case .calories:
                return userExercise.calories
            case .duration:
                return userExercise.duration
            }
            }.reduce(0) { (result, value) -> Int in
                return result + value
        }
        return value
    }

    private class func trackingValue(at date: Date, type: TrackingType) -> Int {
        let trackings = RealmS().objects(Tracking.self).filter { (tracking) -> Bool in
            guard let me = User.me, let user = tracking.userHistory?.user else { return false }
            return me.id == user.id && tracking.createdAt.isInSameDayOf(date: date)
        }
        let value = trackings.map { (tracking) -> Int in
            switch type {
            case .calories:
                return tracking.caloriesBurn
            case .duration:
                return tracking.duration
            case .distance:
                return tracking.distance
            }
            }.reduce(0) { (result, value) -> Int in
                return result + value
        }
        return value
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
        }.reduce(0) { (result, value) -> Int in
            return result + value
        }
        return value
    }

    private class func burnedCalories(at date: Date) -> Int {
        let exercisesBurn = AnalysisViewModel.exerciseValue(at: date, type: .calories)
        let trackingsBurn = AnalysisViewModel.trackingValue(at: date, type: .calories)
        return exercisesBurn + trackingsBurn
    }

    private class func durationFitness(at date: Date) -> Int {
        let exerciseDuration = AnalysisViewModel.exerciseValue(at: date, type: .duration)
        let trackingDuration = AnalysisViewModel.trackingValue(at: date, type: .duration)
        return exerciseDuration + trackingDuration
    }

    private class func distanceFitness(at date: Date) -> Int {
        let distace = AnalysisViewModel.trackingValue(at: date, type: .distance)
        return distace
    }
}
