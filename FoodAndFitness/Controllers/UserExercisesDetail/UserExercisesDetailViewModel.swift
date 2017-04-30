//
//  UserExercisesDetailViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/24/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import RealmS
import RealmSwift
import SwiftDate

protocol UserExercisesDetailViewModelDelegate: class {
    func viewModel(_ viewModel: UserExercisesDetailViewModel, needsPerformAction action: UserExercisesDetailViewModel.Action)
}

final class UserExercisesDetailViewModel {
    var activity: HomeViewController.AddActivity
    var userExercises: [UserExercise] {
        return _userExercises.filter({ (userExercise) -> Bool in
            guard let me = User.me,
                let userHistory = userExercise.userHistory,
                let user = userHistory.user else { return false }
            return userExercise.createdAt.isToday && me.id == user.id
        })
    }
    var suggestExercises: [Exercise] {
        return _suggestExercises.filter({ (_) -> Bool in
            return true
        })
    }
    private let _userExercises: Results<UserExercise>
    private let _suggestExercises: Results<Exercise>
    private var token: NotificationToken?
    weak var delegate: UserExercisesDetailViewModelDelegate?

    enum Action {
        case userExercisesChanged
    }

    init(activity: HomeViewController.AddActivity) {
        self.activity = activity
        _userExercises = RealmS().objects(UserExercise.self)
        _suggestExercises = RealmS().objects(Exercise.self)
        token = _userExercises.addNotificationBlock({ [weak self](change) in
            guard let this = self else { return }
            switch change {
            case .initial(_): break
            case .error(_): break
            case .update(_, deletions: _, insertions: _, modifications: _):
                this.delegate?.viewModel(this, needsPerformAction: .userExercisesChanged)
            }
        })
    }

    func delete(at index: Int, completion: @escaping Completion) {
        guard index >= 0, index < userExercises.count else {
            completion(.failure(NSError(message: Strings.Errors.indexNotValidate)))
            return
        }
        let userExercise = userExercises[index]
        ExerciseServices(userExerciseId: userExercise.id).delete(completion: completion)
    }

    func dataForUserExercise(at index: Int) -> UserFoodCell.Data? {
        guard index >= 0 && index <= userExercises.count - 1 else { return nil }
        let userExercise = userExercises[index]
        guard let exercise = userExercise.exercise else { return nil }
        let name = exercise.name
        let calories = Double(userExercise.duration) * Double(exercise.calories) / Double(exercise.duration)
        let detail = "\(Int(calories)) \(Strings.kilocalories) - \(userExercise.duration) \(Strings.minute)"
        return UserFoodCell.Data(title: name, detail: detail)
    }

    func dataForSuggestExercise(at index: Int) -> UserFoodCell.Data? {
        guard index >= 0 && index <= suggestExercises.count - 1 else { return nil }
        let exercise = suggestExercises[index]
        let name = exercise.name
        let calories = exercise.calories
        let duration = exercise.duration
        let detail = "\(calories) \(Strings.kilocalories) - \(duration) \(Strings.minute)"
        return UserFoodCell.Data(title: name, detail: detail)
    }

    func dataForHeaderView() -> MealHeaderView.Data? {
        let title = activity.title
        let detail = Date().string(format: FFDateFormat.date.dateFormat, in: Region.GMT())
        return MealHeaderView.Data(title: title, detail: detail, image: activity.image)
    }

    func dataForAddButton() -> AddUserFoodCell.Data? {
        return AddUserFoodCell.Data(buttonTitle: Strings.addMoreExercises)
    }

    func dataForInformationExercise(at row: UserExercisesDetailController.InformationRows) -> InfomationNutritionCell.Data? {
        let title = row.title
        var detail = ""
        let value = userExercises.map({ (userExercise) -> Int in
            switch row {
            case .calories:
                return userExercise.calories
            case .duration:
                return userExercise.duration
            }
        }).reduce(0, { (result, value) -> Int in
            return result + value
        })
        if row == .calories {
            detail = "\(value) \(Strings.kilocalories)"
        } else {
            detail = "\(value) \(Strings.minute)"
        }
        return InfomationNutritionCell.Data(title: title, detail: detail)
    }
}
