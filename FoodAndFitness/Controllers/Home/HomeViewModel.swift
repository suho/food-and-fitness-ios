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

protocol HomeViewModelDelegate: class {
    func viewModel(_ viewModel: HomeViewModel, needsPerformAction action: HomeViewModel.Action)
}

final class HomeViewModel {

    private let _userFoods: Results<UserFood>
    private let _userExercises: Results<UserExercise>
    private var userFoods: [UserFood] {
        return _userFoods.filter({ (userFood) -> Bool in
            guard let me = User.me, let user = userFood.user else { return false }
            return userFood.createdAt.isToday && me.id == user.id && userFood.meal.isNotEmpty
        })
    }
    private var userExercises: [UserExercise] {
        return _userExercises.filter({ (userExercise) -> Bool in
            guard let me = User.me, let user = userExercise.user else { return false }
            return userExercise.createdAt.isToday && me.id == user.id
        })
    }

    private var foodsToken: NotificationToken?
    private var exercisesToken: NotificationToken?
    weak var delegate: HomeViewModelDelegate?

    enum Action {
        case userFoodChanged
        case userExerciseChanged
    }

    init() {
        _userFoods = RealmS().objects(UserFood.self)
        _userExercises = RealmS().objects(UserExercise.self)
        foodsToken = _userFoods.addNotificationBlock({ [weak self](change) in
            guard let this = self else { return }
            switch change {
            case .initial(_): break
            case .error(_): break
            case .update(_, deletions: _, insertions: _, modifications: _):
                this.delegate?.viewModel(this, needsPerformAction: .userFoodChanged)
            }
        })
        exercisesToken = _userExercises.addNotificationBlock({ [weak self](change) in
            guard let this = self else { return }
            switch change {
            case .initial(_): break
            case .error(_): break
            case .update(_, deletions: _, insertions: _, modifications: _):
                this.delegate?.viewModel(this, needsPerformAction: .userExerciseChanged)
            }
        })
    }

    func dataForAddActivityCell(activity: HomeViewController.AddActivity) -> AddActivityCell.Data? {
        guard let user = User.me else { return nil }
        let calories = user.caloriesToday
        var recommend = ""
        switch activity {
        case .breakfast:
            let preCalories = Int(calories.percent(value: 40))
            let nextCalories = Int(calories.percent(value: 50))
            recommend = "Recommended: \(preCalories) - \(nextCalories) kcal"
        case .lunch:
            let preCalories = Int(calories.percent(value: 30))
            let nextCalories = Int(calories.percent(value: 40))
            recommend = "Recommended: \(preCalories) - \(nextCalories) kcal"
        case .dinner:
            let preCalories = Int(calories.percent(value: 25))
            let nextCalories = Int(calories.percent(value: 35))
            recommend = "Recommended: \(preCalories) - \(nextCalories) kcal"
        case .exercise:
            guard let goal = user.goal, let goals = Goals(rawValue: goal.id) else { break }
            var minGoal: Int = 30
            switch goals {
            case .beHealthier: break
            case .gainWeight:
                minGoal = 60
            case .loseWeight:
                minGoal = 90
            }
            recommend = "Daily goal: \(minGoal) min"
        case .tracking:
            guard let goal = user.goal, let goals = Goals(rawValue: goal.id) else { break }
            var minGoal: Int = 30
            switch goals {
            case .beHealthier: break
            case .gainWeight:
                minGoal = 60
            case .loseWeight:
                minGoal = 90
            }
            recommend = "Daily goal: \(minGoal) min"
        }
        return AddActivityCell.Data(thumbnail: activity.image, title: activity.title, recommend: recommend, addImage: #imageLiteral(resourceName: "ic_add"))
    }

    func dataForProgressCell() -> ProgressCell.Data? {
        guard let user = User.me else { return nil }
        var eaten = eatenToday()
        let burn = burnToday()
        let calories = user.caloriesToday + Double(burn)
        if Int(calories) - eaten < 0 {
            eaten = Int(calories)
        }
        let carbsString = "\(carbsLeft(calories: calories))" + Strings.gLeft
        let proteinString = "\(proteinLeft(calories: calories))" + Strings.gLeft
        let fatString = "\(fatLeft(calories: calories))" + Strings.gLeft
        return ProgressCell.Data(calories: Int(calories), eaten: eaten, burn: burn, carbs: carbsString, protein: proteinString, fat: fatString)
    }

    func eatenToday() -> Int {
        let eaten = userFoods.map { (userFood) -> Int in
            return userFood.calories
        }.reduce(0) { (result, calories) -> Int in
            return result + calories
        }
        return eaten
    }

    func carbsLeft(calories: Double) -> Int {
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

    func proteinLeft(calories: Double) -> Int {
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

    func fatLeft(calories: Double) -> Int {
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

    func burnToday() -> Int {
        let burn = userExercises.map { (userExercise) -> Int in
            return userExercise.calories
        }.reduce(0) { (result, calories) -> Int in
            return result + calories
        }
        return burn
    }
}
