//
//  ChooseGoalsController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/9/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

final class ChooseGoalsController: BaseViewController {
    @IBOutlet fileprivate(set) weak var beHealthierView: View!
    @IBOutlet fileprivate(set) weak var loseWeightView: View!
    @IBOutlet fileprivate(set) weak var gainWeightView: View!

    enum Action {
        case healthier
        case loseWeight
        case gainWeight

        var goal: Goal {
            let goal = Goal()
            switch self {
            case .healthier:
                goal.id = 1
            case .loseWeight:
                goal.id = 2
            case .gainWeight:
                goal.id = 3
            }
            return goal
        }
    }

    override var isNavigationBarHidden: Bool {
        return true
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configBackground()
    }

    override func setupUI() {
        super.setupUI()
        configAnimation()
    }

    fileprivate func configBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [Color.green64.cgColor, Color.green2.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }

    fileprivate func configAnimation() {
        beHealthierView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        loseWeightView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        gainWeightView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5) {
            self.beHealthierView.transform = .identity
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            UIView.animate(withDuration: 0.5) {
                self.loseWeightView.transform = .identity
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.animate(withDuration: 0.5) {
                self.gainWeightView.transform = .identity
            }
        }
    }

    fileprivate func choose(action: ChooseGoalsController.Action) {
        let chooseActivesController = ChooseActivesController()
        var signUpParams = SignUpParams()
        signUpParams.goal = action.goal
        chooseActivesController.viewModel = ChooseActivesViewModel(params: signUpParams)
        navigationController?.pushViewController(chooseActivesController, animated: true)
    }

    @IBAction fileprivate func beHealthier(_ sender: Any) {
        choose(action: .healthier)
    }

    @IBAction fileprivate func loseWeight(_ sender: Any) {
        choose(action: .loseWeight)
    }

    @IBAction fileprivate func gainWeight(_ sender: Any) {
        choose(action: .gainWeight)
    }

    @IBAction fileprivate func signIn(_ sender: Any) {
        let signInController = SignInController()
        present(signInController, animated: true, completion: nil)
    }
}
