//
//  ChooseGoalsController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/9/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

final class ChooseGoalsController: BaseViewController {

    enum Goals {
        case beHealthier
        case loseWeight
        case gainWeight
    }

    override var isNavigationBarHidden: Bool {
        return true
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
        let signInController = SignInController()
        navigationController?.pushViewController(signInController, animated: true)
    }
}
