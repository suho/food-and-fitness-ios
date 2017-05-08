//
//  UserHistory.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/30/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import RealmSwift
import ObjectMapper
import RealmS
import SwiftDate

final class UserHistory: Object, Mappable {

    private(set) dynamic var id = 0
    dynamic var height: Int = 0
    dynamic var weight: Int = 0
    dynamic var user: User?
    dynamic var goal: Goal?
    dynamic var active: Active?
    dynamic var createdAt: Date = Date()

    override class func primaryKey() -> String? {
        return "id"
    }

    convenience required init?(map: Map) {
        self.init()
        id <- map["id"]
        assert(id > 0, "UserHistory `id` must be greater than 0")
    }

    func mapping(map: Map) {
        height <- map["height"]
        weight <- map["weight"]
        user <- map["user"]
        goal <- map["goal"]
        active <- map["active"]
        createdAt <- (map["created_at"], DataTransform.fullDate)
    }
}

// MARK: - For Nutrition
extension UserHistory {
    var age: Int {
        guard let user = user else { return NSNotFound }
        let now = DateInRegion(absoluteDate: Date()).year
        let birthdayYear = DateInRegion(absoluteDate: user.birthday).year
        return now - birthdayYear
    }

    var caloriesToday: Double {
        guard let user = user,
            let goal = goal, let active = active,
            let goals = Goals(rawValue: goal.id),
            let actives = Actives(rawValue: active.id) else {
                return 0
        }
        var bmrValue = bmr(weight: weight, height: height, age: age, gender: user.gender)
        switch goals {
        case .beHealthier: break
        case .loseWeight:
            bmrValue -= 500
        case .gainWeight:
            bmrValue += 500
        }
        switch actives {
        case .sedentary:
            bmrValue *= 1.2
        case .lightlyActive:
            bmrValue *= 1.4
        case .modertelyActive:
            bmrValue *= 1.6
        case .veryActive:
            bmrValue *= 1.8
        }
        return bmrValue
    }
}
