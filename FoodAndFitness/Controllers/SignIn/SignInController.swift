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
        AppDelegate.shared.gotoHome()
    }
}
