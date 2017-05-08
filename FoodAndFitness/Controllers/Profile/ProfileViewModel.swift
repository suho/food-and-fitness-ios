//
//  ProfileViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 5/8/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

class ProfileViewModel {
    var user: User

    init() {
        guard let user = User.me else {
            fatalError(Strings.Errors.tokenError)
        }
        self.user = user
    }

    func dataForAvatarCell() -> AvatarProfileCell.Data {
        let name = user.name
        let bmi = "BMI: " + user.bmiValue.format(f: ".2")
        var avatarUrl: String? = ApiPath.baseURL + user.avatarUrl
        if user.avatarUrl.isEmpty {
            avatarUrl = nil
        }
        return AvatarProfileCell.Data(name: name, bmi: bmi, avatarUrl: avatarUrl)
    }

    func dataForDetailCell(at row: ProfileViewController.InfoRows) -> DetailCell.Data {
        var detail = ""
        switch row {
        case .weight:
            detail = "\(user.weight) \(Strings.kilogam)"
        case .height:
            detail = "\(user.height) \(Strings.centimeter)"
        case .birthday:
            detail = "\(user.birthday.ffDate().toString(format: .date))"
        case .gender:
            detail = user.gender.description
        case .caloriesPerDay:
            detail = "\(user.caloriesToday)"
        }
        return DetailCell.Data(title: row.title, detail: detail)
    }
}
