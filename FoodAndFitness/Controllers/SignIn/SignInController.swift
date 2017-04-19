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

    @IBAction fileprivate func signIn(_ sender: Any) {
        viewModel.mail = mailField.string
        viewModel.password = passField.string
        HUD.show()
        viewModel.signIn { [weak self] (result) in
            HUD.dismiss()
            guard let this = self else { return }
            switch result {
            case .success(_):
                _ = this.viewModel
                AppDelegate.shared.gotoHome()
            case .failure(let error):
                error.show()
            }
        }
    }
}
