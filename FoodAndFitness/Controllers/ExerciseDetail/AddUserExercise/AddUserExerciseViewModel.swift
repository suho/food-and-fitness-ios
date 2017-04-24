//
//  AddUserExerciseViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/24/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import Foundation

final class AddUserExerciseViewModel {
    var exercise: Exercise

    init(exercise: Exercise) {
        self.exercise = exercise
    }

    func calories(withDuration duration: Int) -> String {
        let ratio = Double(duration) / Double(exercise.duration)
        var calories = ratio * Double(exercise.calories)
        if Int(calories) == 0 {
            calories = 1
        }
        return "\(Int(calories))"
    }
}
