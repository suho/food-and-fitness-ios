//
//  SignInController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/5/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

final class SignInController: BaseViewController {

    override func setupUI() {
        super.setupUI()
        title = Strings.signIn
    }

    @IBAction fileprivate func signIn(_ sender: Any) {
        AppDelegate.shared.gotoHome()
    }
}
