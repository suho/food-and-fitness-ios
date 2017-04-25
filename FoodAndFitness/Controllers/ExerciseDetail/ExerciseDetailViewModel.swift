//
//  ExerciseDetailViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/24/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import RealmSwift
import RealmS

struct UserExerciseParams {
    var exerciseId: Int
    var duration: Int
}

class ExerciseDetailViewModel: NSObject {
    var exercise: Exercise
    var activity: HomeViewController.AddActivity

    init(exercise: Exercise, activity: HomeViewController.AddActivity) {
        self.exercise = exercise
        self.activity = activity
    }

    func save(duration: Int, completion: @escaping Completion) {
        if User.me == nil {
            guard let user = User.me else {
                let error = NSError(message: Strings.Errors.tokenError)
                completion(.failure(error))
                return
            }
        } else {
            let params = UserExerciseParams(exerciseId: exercise.id, duration: duration)
            ExerciseServices.save(params: params, completion: completion)
        }
    }

    func dataForHeaderView() -> MealHeaderView.Data? {
        return MealHeaderView.Data(title: exercise.name, detail: nil, image: activity.image)
    }

    func dataForAddUserExercise() -> AddUserExerciseCell.Data? {
        let `default` = exercise.duration
        let calories = exercise.calories
        return AddUserExerciseCell.Data(default: "\(`default`)", calories: "\(calories)")
    }
}
