//
//  AddNutritionViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/15/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import RealmSwift
import RealmS

final class AddActivityViewModel {
    var activity: HomeViewController.AddActivity

    var foods: Results<Food>?
    var exercises: Results<Exercise>?
    var keyword: String = "" {
        didSet {
            switch activity {
            case .breakfast, .lunch, .dinner:
                if keyword.characters.isEmpty {
                    foods = nil
                } else {
                    updateFoods()
                }
            case .exercise:
                if keyword.characters.isEmpty {
                    exercises = nil
                } else {
                    updateExercises()
                }
            case .tracking: break
            }

        }
    }

    init(activity: HomeViewController.AddActivity) {
        self.activity = activity
    }

    private func updateFoods() {
        let predicate = NSPredicate(format: "name CONTAINS[c] %@", keyword)
        foods = RealmS().objects(Food.self).filter(predicate)
    }

    private func updateExercises() {
        let predicate = NSPredicate(format: "name CONTAINS[c] %@", keyword)
        exercises = RealmS().objects(Exercise.self).filter(predicate)
    }

    func title() -> String {
        return activity.title
    }

    func numberOfRows() -> Int {
        switch activity {
        case .breakfast, .lunch, .dinner:
            guard let foods = foods else { return 0 }
            return foods.count
        case .exercise:
            guard let exercises = exercises else { return 0 }
            return exercises.count
        case .tracking:
            return 0
        }
    }

    func dataForCell(at index: Int) -> ResultCell.Data? {
        switch activity {
        case .breakfast, .lunch, .dinner:
            guard let foods = foods else { return nil }
            guard index >= 0, index < foods.count else { return nil }
            let food = foods[index]
            let title = food.name
            let detail = "\(food.calories) - \(food.weight)"
            return ResultCell.Data(title: title, detail: detail)
        case .exercise:
            guard let exercises = exercises else { return nil }
            guard index >= 0, index < exercises.count else { return nil }
            let exercise = exercises[index]
            let title = exercise.name
            let detail = "\(exercise.calories) - \(exercise.duration)"
            return ResultCell.Data(title: title, detail: detail)
        case .tracking: return nil
        }
    }
}
