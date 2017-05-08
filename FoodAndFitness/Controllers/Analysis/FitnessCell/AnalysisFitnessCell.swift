//
//  AnalysisFitnessCell.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 5/1/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

class AnalysisFitnessCell: BaseTableViewCell {
    @IBOutlet fileprivate(set) weak var caloriesLabel: UILabel!
    @IBOutlet fileprivate(set) weak var durationLabel: UILabel!
    @IBOutlet fileprivate(set) weak var distanceLabel: UILabel!

    struct Data {
        var calories: String
        var duration: String
        var distance: String
    }

    var data: Data? {
        didSet {
            guard let data = data else { return }
            caloriesLabel.text = data.calories
            durationLabel.text = data.duration
            distanceLabel.text = data.distance
        }
    }
}
