//
//  SignUpViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/10/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import Foundation

struct SignUpParams {
    var goal: Goal?
    var active: Active?
}

class SignUpViewModel {

    var signUpParams: SignUpParams

    init(params: SignUpParams) {
        signUpParams = params
    }

}
