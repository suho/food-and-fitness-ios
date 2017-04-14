//
//  SignInViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/14/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

class SignInViewModel {

    var mail: String = ""
    var password: String = ""

    init(user: User?) {
        guard let user = user else { return }
        mail = user.email
    }
}
