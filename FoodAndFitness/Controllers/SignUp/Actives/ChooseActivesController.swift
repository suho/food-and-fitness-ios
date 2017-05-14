//
//  ChooseActivesController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/10/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

final class ChooseActivesController: BaseViewController {

    var viewModel: ChooseActivesViewModel!

    override var isNavigationBarHidden: Bool {
        return true
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configBackground()
    }

    fileprivate func choose(active: Active) {
        viewModel.signUpParams.active = active
        let signUpController = SignUpController()
        signUpController.viewModel = SignUpViewModel(params: viewModel.signUpParams)
        navigationController?.pushViewController(signUpController, animated: true)
    }

    fileprivate func configBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [Color.green64.cgColor, Color.green2.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }

    @IBAction fileprivate func sedentary(_ sender: Any) {
        let active = Active()
        active.id = 1
        choose(active: active)
    }

    @IBAction fileprivate func lightlyActive(_ sender: Any) {
        let active = Active()
        active.id = 2
        choose(active: active)
    }

    @IBAction fileprivate func moderatelyActive(_ sender: Any) {
        let active = Active()
        active.id = 3
        choose(active: active)
    }

    @IBAction fileprivate func veryActive(_ sender: Any) {
        let active = Active()
        active.id = 4
        choose(active: active)
    }
}
