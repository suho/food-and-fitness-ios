//
//  UILabel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/5/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(text: String) {
        self.init(frame: UIScreen.main.bounds)
        self.text = text
        self.sizeToFit()
    }
}
