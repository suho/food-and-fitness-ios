//
//  FoodDetailViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/15/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import RealmSwift
import RealmS

struct UserFoodParams {
    var userId: Int
    var foodId: Int
    var weight: Int
    var meal: String
}

final class FoodDetailViewModel {
    var food: Food
    var activity: HomeViewController.AddActivity

    init(food: Food, activity: HomeViewController.AddActivity) {
        self.food = food
        self.activity = activity
    }

    func dataForHeaderView() -> MealHeaderView.Data? {
        return MealHeaderView.Data(title: food.name, detail: nil, image: activity.image)
    }

    func save(weight: Int, completion: @escaping Completion) {
        guard let user = User.me else {
            let error = NSError(message: Strings.Errors.tokenError)
            completion(.failure(error))
            return
        }
        let params = UserFoodParams(userId: user.id, foodId: food.id, weight: weight, meal: activity.title)
        FoodServices.save(params: params, completion: completion)
    }

    func dataForInformationFood() -> InformationFoodCell.Data {
        let maxValue = Double(food.carbs + food.protein + food.fat)
        let carbs = Double(food.carbs).percent(max: maxValue)
        let protein = Double(food.protein).percent(max: maxValue)
        let fat = Double(food.fat).percent(max: maxValue)
        return InformationFoodCell.Data(carbs: Int(carbs), protein: Int(protein), fat: Int(fat))
    }

    func dataForSaveUserFood() -> SaveUserFoodCell.Data? {
        let `default` = food.weight
        let calories = food.calories
        return SaveUserFoodCell.Data(default: "\(`default`)", calories: "\(calories)")
    }
}
