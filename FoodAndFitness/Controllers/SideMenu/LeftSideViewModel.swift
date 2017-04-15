//
//  LeftSideViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/13/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import RealmS
import RealmSwift

final class LeftSideViewModel {
    let user: User?
    private let notificationToken: NotificationToken?

    init() {
        user = User.me
        notificationToken = user?.addNotificationBlock({ (change) in
            switch change {
            case .change(let properties):
                print(properties)
            case .deleted: break
            case .error(_): break
            }
        })
    }

    func dataForUserProfile() -> UserProfileCell.Data? {
        guard let user = user else { return nil }
        var url: String?
        if user.avatarUrl.characters.isNotEmpty {
            url = ApiPath.baseURL + user.avatarUrl
        }
        let bmi = "BMI: " + user.bmiValue.format(f: ".2")
        return UserProfileCell.Data(avatarUrl: url, userName: user.name, bmi: bmi)
    }
}
