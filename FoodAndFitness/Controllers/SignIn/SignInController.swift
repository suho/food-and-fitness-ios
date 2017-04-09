//
//  SignInController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/5/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

class SignInController: BaseViewController {
    override var isNavigationBarHidden: Bool {
        return true
    }

    @IBAction fileprivate func signIn(_ sender: Any) {
        AppDelegate.shared.gotoHome()
    }
}
