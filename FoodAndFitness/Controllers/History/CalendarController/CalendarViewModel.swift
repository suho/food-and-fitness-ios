//
//  CalendarViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/24/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import RealmSwift
import RealmS
import SwiftDate

class CalendarViewModel {
    func didHaveEvents(forDate date: Date) -> Bool {
        let userFoods: [UserFood] = RealmS().objects(UserFood.self).filter { (userFood) -> Bool in
            guard let me = User.me, let user = userFood.user else { return false }
            return me.id == user.id && userFood.createdAt.isInSameDayOf(date: date)
        }
        let userExercises: [UserExercise] = RealmS().objects(UserExercise.self).filter({ (userExercise) -> Bool in
            guard let me = User.me, let user = userExercise.user else { return false }
            return me.id == user.id && userExercise.createdAt.isInSameDayOf(date: date)
        })
        return userFoods.isNotEmpty || userExercises.isNotEmpty
    }
}
