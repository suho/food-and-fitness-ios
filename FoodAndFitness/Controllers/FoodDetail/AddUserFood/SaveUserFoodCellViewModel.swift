//
//  SaveUserFoodCellViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/23/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import Foundation

final class SaveUserFoodCellViewModel {
    var food: Food

    init(food: Food) {
        self.food = food
    }

    func calories(withWeight weight: Int) -> String {
        let ratio = Double(weight) / Double(food.weight)
        var calories = ratio * Double(food.calories)
        if Int(calories) == 0 {
            calories = 1
        }
        return "\(Int(calories))"
    }
}
