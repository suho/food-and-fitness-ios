//
//  HistoryViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/26/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import RealmS
import RealmSwift
import SwiftDate

class HistoryViewModel {

    let breakfastFoods: [UserFood]
    let lunchFoods: [UserFood]
    let dinnerFoods: [UserFood]
    let userExercises: [UserExercise]
    let trackings: [Tracking]
    let date: Date
    fileprivate let userFoods: [UserFood]

    init(date: Date) {
        self.date = date
        let realm = RealmS()
        userFoods = realm.objects(UserFood.self).filter { (userFood) -> Bool in
            guard let me = User.me, let user = userFood.userHistory?.user else { return false }
            return me.id == user.id && userFood.createdAt.isInSameDayOf(date: date)
        }
        breakfastFoods = userFoods.filter({ (userFood) -> Bool in
            return userFood.meal == HomeViewController.AddActivity.breakfast.title
        })
        lunchFoods = userFoods.filter({ (userFood) -> Bool in
            return userFood.meal == HomeViewController.AddActivity.lunch.title
        })
        dinnerFoods = userFoods.filter({ (userFood) -> Bool in
            return userFood.meal == HomeViewController.AddActivity.dinner.title
        })
        userExercises = realm.objects(UserExercise.self).filter({ (userExercise) -> Bool in
            guard let me = User.me, let user = userExercise.userHistory?.user else { return false }
            return me.id == user.id && userExercise.createdAt.isInSameDayOf(date: date)
        })
        trackings = realm.objects(Tracking.self).filter { (tracking) -> Bool in
            guard let me = User.me, let user = tracking.userHistory?.user else { return false }
            return me.id == user.id && tracking.createdAt.isInSameDayOf(date: date)
        }
    }

    func dataForProgressCell() -> ProgressCell.Data? {
        guard let userHistory = RealmS().objects(UserHistory.self).filter({ (userHistory) -> Bool in
            let userHistoryDate = DateInRegion(absoluteDate: userHistory.createdAt).ffDate()
            let historyDate = DateInRegion(absoluteDate: self.date).ffDate()
            return userHistoryDate <= historyDate
        }).last else { return nil }
        var eaten = eatenToday()
        let burn = burnToday()
        let calories = userHistory.caloriesToday + Double(burn)
        if Int(calories) - eaten < 0 {
            eaten = Int(calories)
        }
        let carbsString = "\(carbsLeft(calories: calories))" + Strings.gLeft
        let proteinString = "\(proteinLeft(calories: calories))" + Strings.gLeft
        let fatString = "\(fatLeft(calories: calories))" + Strings.gLeft
        return ProgressCell.Data(calories: Int(calories), eaten: eaten, burn: burn, carbs: carbsString, protein: proteinString, fat: fatString)
    }

    private func eatenToday() -> Int {
        let eaten = userFoods.map { (userFood) -> Int in
            return userFood.calories
            }.reduce(0) { (result, calories) -> Int in
                return result + calories
        }
        return eaten
    }

    private func carbsLeft(calories: Double) -> Int {
        let carbsUserFoods = userFoods.map { (userFood) -> Int in
            return userFood.carbs
            }.reduce(0) { (result, carbs) -> Int in
                return result + carbs
        }
        let carbsLeft = carbs(calories: calories) - carbsUserFoods
        if carbsLeft < 0 {
            return 0
        } else {
            return carbsLeft
        }
    }

    private func proteinLeft(calories: Double) -> Int {
        let proteinUserFoods = userFoods.map { (userFood) -> Int in
            return userFood.protein
            }.reduce(0) { (result, protein) -> Int in
                return result + protein
        }
        let proteinLeft = protein(calories: calories) - proteinUserFoods
        if proteinLeft < 0 {
            return 0
        } else {
            return proteinLeft
        }
    }

    private func fatLeft(calories: Double) -> Int {
        let fatUserFoods = userFoods.map { (userFood) -> Int in
            return userFood.fat
            }.reduce(0) { (result, fat) -> Int in
                return result + fat
        }
        let fatLeft = fat(calories: calories) - fatUserFoods
        if fatLeft < 0 {
            return 0
        } else {
            return fatLeft
        }
    }

    private func burnToday() -> Int {
        let exercisesBurn = userExercises.map { (userExercise) -> Int in
            return userExercise.calories
            }.reduce(0) { (result, calories) -> Int in
                return result + calories
        }
        let trackingsBurn = trackings.map { (tracking) -> Int in
            return tracking.caloriesBurn
            }.reduce(0) { (result, calories) -> Int in
                return result + calories
        }
        return exercisesBurn + trackingsBurn
    }
}
