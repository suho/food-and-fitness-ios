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

    init(date: Date) {
        let realm = RealmS()
        let userFoods: [UserFood] = realm.objects(UserFood.self).filter { (userFood) -> Bool in
            guard let me = User.me, let user = userFood.user else { return false }
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
            guard let me = User.me, let user = userExercise.user else { return false }
            return me.id == user.id && userExercise.createdAt.isInSameDayOf(date: date)
        })
        trackings = realm.objects(Tracking.self).filter { (tracking) -> Bool in
            guard let me = User.me, let user = tracking.user else { return false }
            return me.id == user.id && tracking.createdAt.isInSameDayOf(date: date)
        }
    }
}
