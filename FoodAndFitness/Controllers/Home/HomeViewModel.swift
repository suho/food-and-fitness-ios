//
//  HomeViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/16/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import RealmSwift
import RealmS

class HomeViewModel {

    var userFoods: Results<UserFood>
    var userExercises: Results<UserExercise>

    init() {
        userFoods = RealmS().objects(UserFood.self)
        userExercises = RealmS().objects(UserExercise.self)
    }

    func dataForAddActivityCell(activity: HomeViewController.AddActivity) -> AddActivityCell.Data? {
        return AddActivityCell.Data(thumbnail: activity.image, title: activity.title, recommend: nil, addImage: nil)
    }

    func dataForProgressCell() -> ProgressCell.Data? {
        guard let user = User.me else { return nil }
        let eaten = eatenToday() + 200
        let burn = burnToday() + 1000
        let calories = user.caloriesToday + Double(burn)
        let carbsString = "\(carbs(calories: calories))" + Strings.gLeft
        let proteinString = "\(protein(calories: calories))" + Strings.gLeft
        let fatString = "\(fat(calories: calories))" + Strings.gLeft
        return ProgressCell.Data(calories: Int(calories), eaten: eaten, burn: burn, carbs: carbsString, protein: proteinString, fat: fatString)
    }

    func eatenToday() -> Int {
        var eaten = 0
        for userFood in userFoods {
            guard let food = userFood.food else { continue }
            let ratio = Double(userFood.weight) / Double(food.weight)
            let calories = ratio * Double(food.calories)
            eaten += Int(calories)
        }
        return eaten
    }

    func burnToday() -> Int {
        var burn = 0
        for userExercise in userExercises {
            guard let exercise = userExercise.exercise else { continue }
            let ratio = Double(userExercise.duration) / Double(exercise.duration)
            let calories = ratio * Double(exercise.calories)
            burn += Int(calories)
        }
        return burn
    }
}
