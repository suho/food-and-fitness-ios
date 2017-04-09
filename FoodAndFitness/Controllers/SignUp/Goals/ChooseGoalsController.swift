//
//  ChooseGoalsController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/9/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

class ChooseGoalsController: BaseViewController {

    enum Goals {
        case beHealthier
        case loseWeight
        case gainWeight
    }

    fileprivate func choose(goal: ChooseGoalsController.Goals) {
        
    }

    @IBAction fileprivate func beHealthier(_ sender: Any) {
        choose(goal: .beHealthier)
    }

    @IBAction fileprivate func loseWeight(_ sender: Any) {
        choose(goal: .loseWeight)
    }

    @IBAction fileprivate func gainWeight(_ sender: Any) {
        choose(goal: .loseWeight)
    }

    @IBAction fileprivate func signIn(_ sender: Any) {
        
    }
}
