//
//  ProfileViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 5/8/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import RealmSwift

protocol ProfileViewModelDelegate: class {
    func viewModel(_ viewModel: ProfileViewModel, needsPerformAction action: ProfileViewModel.Action)
}

class ProfileViewModel {
    var user: User
    weak var delegate: ProfileViewModelDelegate?
    private var userToken: NotificationToken?

    enum Action {
        case updated
    }

    init() {
        guard let user = User.me else {
            fatalError(Strings.Errors.tokenError)
        }
        self.user = user
        userToken = self.user.addNotificationBlock({ (change) in
            switch change {
            case .change(_):
                self.delegate?.viewModel(self, needsPerformAction: .updated)
            default: break
            }
        })
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
        var detailColor: UIColor = .lightGray
        switch row {
        case .mail:
            detail = user.email
        case .weight:
            detail = "\(user.weight) \(Strings.kilogam)"
            detailColor = .black
        case .height:
            detail = "\(user.height) \(Strings.centimeter)"
            detailColor = .black
        case .birthday:
            detail = "\(user.birthday.ffDate().toString(format: .date))"
        case .gender:
            detail = user.gender.description
        case .caloriesPerDay:
            detail = "\(user.caloriesToday)"
        case .goal:
            let name = user.goal?.name
            detail = "\(name.toString())"
            detailColor = .black
        case .active:
            let name = user.active?.name
            detail = "\(name.toString())"
            detailColor = .black
        }
        return DetailCell.Data(title: row.title, detail: detail, detailColor: detailColor)
    }
}
