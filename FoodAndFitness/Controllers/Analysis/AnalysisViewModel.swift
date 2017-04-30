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

    var eatenCalories: [Int] = [Int]()
    var burnedCalories: [Int] = [Int]()

    init() {
        let now = DateInRegion(absoluteDate: Date())
        for i in 0..<7 {
            let date = now - (7 - i).days
            let eaten = AnalysisViewModel.eatenCalories(at: date.absoluteDate)
            let burned = AnalysisViewModel.burnedCalories(at: date.absoluteDate)
            self.eatenCalories.append(eaten)
            self.burnedCalories.append(burned)
        }
    }

    func dataForChartView() -> ChartViewCell.Data {
        return ChartViewCell.Data(eatenCalories: eatenCalories, burnedCalories: burnedCalories)
    }

    private class func eatenCalories(at date: Date) -> Int {
        let userFoods = RealmS().objects(UserFood.self).filter { (userFood) -> Bool in
            guard let me = User.me, let user = userFood.userHistory?.user else { return false }
            return me.id == user.id && userFood.createdAt.isInSameDayOf(date: date)
        }
        let eaten = userFoods.map { (userFood) -> Int in
            return userFood.calories
        }.reduce(0) { (result, calories) -> Int in
            return result + calories
        }
        return eaten
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
