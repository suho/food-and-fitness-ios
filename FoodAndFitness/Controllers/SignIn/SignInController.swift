//
//  SignInController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/5/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

final class SignInController: BaseViewController {
    @IBOutlet fileprivate(set) weak var mailField: UITextField!
    @IBOutlet fileprivate(set) weak var passField: UITextField!
    @IBOutlet fileprivate(set) weak var signInButton: UIButton!

    var viewModel: SignInViewModel = SignInViewModel(user: nil)

    override func setupUI() {
        super.setupUI()
        title = Strings.signIn
    }

    private func getData() {
        let group = DispatchGroup()
        group.enter()
        viewModel.getUserFoods { [weak self](result) in
            guard self != nil else { return }
            group.leave()
            switch result {
            case .success(_): break
            case .failure(let error):
                HUD.dismiss()
                error.show()
            }
        }
        group.enter()
        viewModel.getUserExercises { [weak self](result) in
            guard self != nil else { return }
            group.leave()
            switch result {
            case .success(_): break
            case .failure(let error):
                HUD.dismiss()
                error.show()
            }
        }
        group.enter()
        viewModel.getTrackings { [weak self](result) in
            guard self != nil else { return }
            group.leave()
            switch result {
            case .success(_): break
            case .failure(let error):
                HUD.dismiss()
                error.show()
            }
        }
        group.notify(queue: .main) {
            HUD.dismiss()
            AppDelegate.shared.gotoHome()
        }
    }

    @IBAction fileprivate func signIn(_ sender: Any) {
        viewModel.mail = mailField.string
        viewModel.password = passField.string
        HUD.show()
        viewModel.signIn { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success(_):
                this.getData()
            case .failure(let error):
                HUD.dismiss()
                error.show()
            }
        }
    }
}
