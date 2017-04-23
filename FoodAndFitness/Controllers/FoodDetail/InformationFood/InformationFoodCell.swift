//
//  InformationFoodCell.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/23/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

class InformationFoodCell: BaseTableViewCell {
    @IBOutlet fileprivate(set) weak var carbsProgressView: CircleProgressView!
    @IBOutlet fileprivate(set) weak var proteinProgressView: CircleProgressView!
    @IBOutlet fileprivate(set) weak var fatProgressView: CircleProgressView!
    @IBOutlet fileprivate(set) weak var carbsPercentLabel: UILabel!
    @IBOutlet fileprivate(set) weak var proteinPercentLabel: UILabel!
    @IBOutlet fileprivate(set) weak var fatPercentLabel: UILabel!

    struct Data {
        var carbs: Int
        var protein: Int
        var fat: Int
    }

    var data: Data? {
        didSet {
            guard let data = data else { return }
            carbsProgressView.setValue(CGFloat(data.carbs))
            carbsPercentLabel.text = "\(data.carbs)%"
            proteinProgressView.setValue(CGFloat(data.protein))
            proteinPercentLabel.text = "\(data.protein)%"
            fatProgressView.setValue(CGFloat(data.fat))
            fatPercentLabel.text = "\(data.fat)%"
        }
    }
}
