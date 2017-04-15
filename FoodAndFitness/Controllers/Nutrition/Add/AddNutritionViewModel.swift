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

final class AddNutritionViewModel {
    var meal: HomeViewController.AddActivity
    var foods: Results<Food>?
    var keyword: String = "" {
        didSet {
            if keyword.characters.isEmpty {
                foods = nil
            } else {
                updateFoods()
            }
        }
    }

    init(meal: HomeViewController.AddActivity) {
        self.meal = meal
    }

    private func updateFoods() {
        let predicate = NSPredicate(format: "name CONTAINS[c] %@", keyword)
        foods = RealmS().objects(Food.self).filter(predicate)
    }

    func title() -> String {
        switch meal {
        case .breakfast:
            return Strings.addBreakfast
        case .lunch:
            return Strings.addLunch
        case .dinner:
            return Strings.addDinner
        default:
            return Strings.empty
        }
    }

    func dataForCell(at index: Int) -> FoodResultCell.Data? {
        guard let foods = foods else { return nil }
        guard index >= 0, index < foods.count else { return nil }
        let food = foods[index]
        let title = food.name
        let detail = "\(food.calories) - \(food.weight)"
        return FoodResultCell.Data(title: title, detail: detail)
    }
}
