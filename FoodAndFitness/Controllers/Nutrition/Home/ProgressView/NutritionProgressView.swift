//
//  NutritionProgressView.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/28/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

class NutritionProgressView: UIView {
    @IBOutlet fileprivate(set) weak var progressView: CircleProgressView!

    func setup(_ value: CGFloat, duration: CFTimeInterval) {
        progressView.setValue(value, duration: duration)
    }
}
