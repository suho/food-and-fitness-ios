//
//  UITextField.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/5/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

extension UITextField {
    func setUnit(text unit: String, textColor: UIColor) {
        let unit = UILabel(text: " \(unit)")
        unit.textColor = textColor
        self.rightViewMode = .always
        self.rightView = unit
        self.text = "0"
    }
}
