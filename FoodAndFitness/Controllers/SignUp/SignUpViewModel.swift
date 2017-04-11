//
//  SignUpViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/10/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import Foundation
import UIKit

struct SignUpParams {
    var avatar: UIImage?
    var fullName: String?
    var email: String?
    var password: String?
    var confirmPassword: String?
    var birthday: String?
    var gender: Int = 1
    var height: Int?
    var weight: Int?
    var goal: Goal?
    var active: Active?

    init() {}
}

class SignUpViewModel {

    enum Validation {
        case success
        case failure(message: String)
    }

    var signUpParams: SignUpParams

    init(params: SignUpParams) {
        signUpParams = params
    }

    private func validate() -> Validation {

        return .success
    }

    func signUp(completion: @escaping Completion) {

    }
}
