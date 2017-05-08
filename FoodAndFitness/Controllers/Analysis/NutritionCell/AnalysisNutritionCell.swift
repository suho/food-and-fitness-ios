//
//  AnalysisNutritionCell.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 5/1/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

class AnalysisNutritionCell: BaseTableViewCell {
    @IBOutlet fileprivate(set) weak var caloriesLabel: UILabel!
    @IBOutlet fileprivate(set) weak var proteinLabel: UILabel!
    @IBOutlet fileprivate(set) weak var carbsLabel: UILabel!
    @IBOutlet fileprivate(set) weak var fatLabel: UILabel!

    struct Data {
        var calories: String
        var protein: String
        var carbs: String
        var fat: String
    }

    var data: Data? {
        didSet {
            guard let data = data else { return }
            caloriesLabel.text = data.calories
            proteinLabel.text = data.protein
            carbsLabel.text = data.carbs
            fatLabel.text = data.fat
        }
    }
}
