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
import FSCalendar

class CalendarViewModel {

    var selectedCell: FSCalendarCell?
    var selectedDate: Date?

    func didHaveEvents(forDate date: Date) -> Bool {
        guard let me = User.me else { return false }
        let realm = RealmS()
        let userFoods: [UserFood] = realm.objects(UserFood.self).filter { (userFood) -> Bool in
            guard let user = userFood.user else { return false }
            return me.id == user.id && userFood.createdAt.isInSameDayOf(date: date)
        }
        let userExercises: [UserExercise] = realm.objects(UserExercise.self).filter({ (userExercise) -> Bool in
            guard let user = userExercise.user else { return false }
            return me.id == user.id && userExercise.createdAt.isInSameDayOf(date: date)
        })
        let trackings: [Tracking] = realm.objects(Tracking.self).filter { (tracking) -> Bool in
            guard let user = tracking.user else { return false }
            return me.id == user.id && tracking.createdAt.isInSameDayOf(date: date)
        }
        return userFoods.isNotEmpty || userExercises.isNotEmpty || trackings.isNotEmpty
    }
}
