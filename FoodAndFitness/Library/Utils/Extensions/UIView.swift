//
//  UIView.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/26/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func removeAllSubviews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }

    func viewDidUpdated() {
        let nc = NotificationCenter.default
        nc.post(name: .viewDidUpdated, object: self)
    }
}
