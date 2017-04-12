//
//  LeftSideViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/13/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

class LeftSideViewModel {
    func dataForUserProfile() -> UserProfileCell.Data? {
        guard let user = User.me else { return nil }
        var url: String?
        if user.avatarUrl.characters.isNotEmpty {
            url = ApiPath.baseURL + user.avatarUrl
        }
        let bmi = "BMI: " + user.bmiValue.format(f: ".2")
        return UserProfileCell.Data(avatarUrl: url, userName: user.name, bmi: bmi)
    }
}
