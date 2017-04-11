//
//  ChooseGoalsController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/9/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

final class ChooseGoalsController: BaseViewController {

    override var isNavigationBarHidden: Bool {
        return true
    }

    fileprivate func choose(goal: Goal) {
        let chooseActivesController = ChooseActivesController()
        var signUpParams = SignUpParams()
        signUpParams.goal = goal
        chooseActivesController.viewModel = ChooseActivesViewModel(params: signUpParams)
        navigationController?.pushViewController(chooseActivesController, animated: true)
    }

    @IBAction fileprivate func beHealthier(_ sender: Any) {
        let goal = Goal()
        goal.id = 1
        choose(goal: goal)
    }

    @IBAction fileprivate func loseWeight(_ sender: Any) {
        let goal = Goal()
        goal.id = 2
        choose(goal: goal)
    }

    @IBAction fileprivate func gainWeight(_ sender: Any) {
        let goal = Goal()
        goal.id = 3
        choose(goal: goal)
    }

    @IBAction fileprivate func signIn(_ sender: Any) {
        let signInController = SignInController()
        navigationController?.pushViewController(signInController, animated: true)
    }
}
