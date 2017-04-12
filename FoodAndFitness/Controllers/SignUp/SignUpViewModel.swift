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

    var signUpParams: SignUpParams

    init(params: SignUpParams) {
        signUpParams = params
    }

    private func validate() -> Validation {
        if let fullName = signUpParams.fullName, fullName.characters.count > Validation.maxInput {
            return .failure(Strings.Errors.fullNameError)
        }
        guard let email = signUpParams.email, email.validate(RegularExpressionPattern.RFCStandarEmail.rawValue) else {
            return .failure(Strings.Errors.emailError)
        }
        guard let password = signUpParams.password, let confirmPassword = signUpParams.confirmPassword, password == confirmPassword else {
            return .failure(Strings.Errors.passwordError)
        }
        guard let height = signUpParams.height, height > Validation.minHeightInput else {
            return .failure(Strings.Errors.heightError)
        }
        guard let weight = signUpParams.weight, weight > Validation.minWeightInput else {
            return .failure(Strings.Errors.weightError)
        }
        return .success
    }

    func signUp(completion: @escaping Completion) {
        let status = validate()
        switch status {
        case .success:
            _ = UserServices.signUp(params: signUpParams, completion: completion)
        case .failure(let message):
            completion(.failure(NSError(message: message)))
        }
    }

    func uploadPhoto(completion: @escaping Completion) {
        guard let avatar = signUpParams.avatar else {
            let error = NSError(message: Strings.Errors.emptyImage)
            completion(.failure(error))
            return
        }
        UserServices.upload(image: avatar, completion: completion)
    }
}
