//
//  SignInViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/14/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

final class SignInViewModel {

    var mail: String = ""
    var password: String = ""

    init(user: User?) {
        guard let user = user else { return }
        mail = user.email
    }

    private func validate() -> Validation {
        guard mail.validate(RegularExpressionPattern.RFCStandarEmail.rawValue) else {
                return .failure(Strings.Errors.emailError)
        }
        guard password.characters.count >= Validation.minPasswordInput,
            password.characters.count <= Validation.maxPasswordInput else {
                return .failure(Strings.Errors.passwordError)
        }
        return .success
    }

    func signIn(completion: @escaping Completion) {
        let validate = self.validate()
        switch validate {
        case .success:
            let params = SignInParams(email: mail, password: password)
            UserServices.signIn(params: params, completion: completion)
        case .failure(let message):
            completion(.failure(NSError(message: message)))
        }
    }
}

struct SignInParams {
    let email: String
    let password: String
}
