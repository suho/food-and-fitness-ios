//
//  UserExercise.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/9/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//
import RealmSwift
import ObjectMapper
import RealmS

final class UserExercise: Object, Mappable {

    private(set) dynamic var id = 0
    dynamic var userHistory: UserHistory?
    private(set) dynamic var exercise: Exercise?
    private(set) dynamic var duration: Int = 0
    private(set) dynamic var createdAt: Date = Date()

    override class func primaryKey() -> String? {
        return "id"
    }

    convenience required init?(map: Map) {
        self.init()
        id <- map["id"]
        assert(id > 0, "UserExercise `id` must be greater than 0")
    }

    func mapping(map: Map) {
        userHistory <- map["user_history"]
        exercise <- map["exercise"]
        duration <- map["duration"]
        createdAt <- map["created_at"]
    }
}

// MARK: - Utils
extension UserExercise {
    fileprivate var ratio: Double {
        guard let exercise = exercise else { return 1 }
        return Double(duration) / Double(exercise.duration)
    }

    var calories: Int {
        guard let exercise = exercise else { return 0 }
        let calories = ratio * Double(exercise.calories)
        return Int(calories)
    }
}
