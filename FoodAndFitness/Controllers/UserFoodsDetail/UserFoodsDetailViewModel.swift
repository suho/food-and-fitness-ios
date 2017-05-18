//
//  UserFoodsDetailViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/16/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import RealmS
import RealmSwift
import SwiftDate

protocol UserFoodsDetailViewModelDelegate: class {
    func viewModel(_ viewModel: UserFoodsDetailViewModel, needsPerformAction action: UserFoodsDetailViewModel.Action)
}

final class UserFoodsDetailViewModel {

    var activity: HomeViewController.AddActivity
    var userFoods: [UserFood] {
        return _userFoods.filter({ (userFood) -> Bool in
            guard let me = User.me, let user = userFood.userHistory?.user else { return false }
            return userFood.createdAt.isToday && me.id == user.id && userFood.meal == activity.title
        })
    }
    var suggestFoods: [Food] {
        return _suggestFoods.filter({ (food) -> Bool in
            return self.filterSuggestFoods(food: food)
        })
    }
    private let _userFoods: Results<UserFood>
    private let _suggestFoods: Results<Food>
    private var token: NotificationToken?
    weak var delegate: UserFoodsDetailViewModelDelegate?

    enum Action {
        case userFoodChanged
    }

    init(activity: HomeViewController.AddActivity) {
        self.activity = activity
        _userFoods = RealmS().objects(UserFood.self)
        _suggestFoods = RealmS().objects(Food.self)
        token = _userFoods.addNotificationBlock({ [weak self](change) in
            guard let this = self else { return }
            switch change {
            case .initial(_): break
            case .error(_): break
            case .update(_, deletions: _, insertions: _, modifications: _):
                this.delegate?.viewModel(this, needsPerformAction: .userFoodChanged)
            }
        })
    }

    private func filterSuggestFoods(food: Food) -> Bool {
        guard let user = User.me, let goal = user.goal, let goals = Goals(rawValue: goal.id) else {
            return false
        }
        let calories = food.calories
        switch goals {
        case .beHealthier:
            return calories > 100 && calories < 250
        case .gainWeight:
            return calories >= 250
        case .loseWeight:
            return calories <= 100
        }
    }

    func delete(at index: Int, completion: @escaping Completion) {
        guard index >= 0, index < userFoods.count else {
            completion(.failure(NSError(message: Strings.Errors.indexNotValidate)))
            return
        }
        let userFood = userFoods[index]
        FoodServices(userFoodId: userFood.id).delete(completion: completion)
    }

    func dataForUserFood(at index: Int) -> UserFoodCell.Data? {
        guard index >= 0 && index <= userFoods.count - 1 else { return nil }
        let userFood = userFoods[index]
        guard let food = userFood.food else { return nil }
        let name = food.name
        let calories = Double(userFood.weight) * Double(food.calories) / Double(food.weight)
        return UserFoodCell.Data(title: name, detail: "\(Int(calories)) kcal - \(userFood.weight) g", image: #imageLiteral(resourceName: "ic_food"))
    }

    func dataForSuggestFood(at index: Int) -> UserFoodCell.Data? {
        guard index >= 0 && index <= suggestFoods.count - 1 else { return nil }
        let food = suggestFoods[index]
        let name = food.name
        let calories = food.calories
        let weight = food.weight
        return UserFoodCell.Data(title: name, detail: "\(calories) kcal - \(weight) g", image: #imageLiteral(resourceName: "ic_food"))
    }

    func dataForHeaderView() -> MealHeaderView.Data? {
        let title = activity.title
        let detail = Date().string(format: FFDateFormat.date.dateFormat, in: Region.GMT())
        return MealHeaderView.Data(title: title, detail: detail, image: activity.image)
    }

    func dataForAddButton() -> AddUserFoodCell.Data? {
        return AddUserFoodCell.Data(buttonTitle: Strings.addMoreFoods)
    }

    func dataForInformationNutrition(at row: UserFoodsDetailController.InformationRows) -> InfomationNutritionCell.Data? {
        let title = row.title
        var detail = ""
        let value = userFoods.map({ (userFood) -> Int in
            switch row {
            case .calories:
                return userFood.calories
            case .protein:
                return userFood.protein
            case .carbs:
                return userFood.carbs
            case .fat:
                return userFood.fat
            }
        }).reduce(0, { (result, value) -> Int in
            return result + value
        })
        if row == .calories {
            detail = "\(value) \(Strings.kilocalories)"
        } else {
            detail = "\(value) g"
        }
        return InfomationNutritionCell.Data(title: title, detail: detail)
    }
}
