//
//  User.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 6/19/16.
//  Copyright © 2016 SuHoVan. All rights reserved.
//

import RealmSwift
import ObjectMapper
import RealmS
import SwiftDate

final class User: Object, Mappable {

    private(set) dynamic var id = 0
    private(set) dynamic var name: String = ""
    private(set) dynamic var email: String = ""
    private(set) dynamic var avatarUrl: String = ""
    private(set) dynamic var birthday: Date = Date(timeIntervalSince1970: 0)
    private(set) dynamic var genderRaw = Gender.others.rawValue
    private(set) dynamic var height: Int = 0
    private(set) dynamic var weight: Int = 0
    private(set) dynamic var goal: Goal?
    private(set) dynamic var active: Active?

    var gender: Gender {
        set {
            genderRaw = newValue.rawValue
        }
        get {
            let gender = Gender(rawValue: genderRaw)
            if let gender = gender {
                return gender
            } else {
                return .others
            }
        }
    }

    override class func primaryKey() -> String? {
        return "id"
    }

    convenience required init?(map: Map) {
        self.init()
        id <- map["id"]
        assert(id > 0, "User `id` must be greater than 0")
    }

    func mapping(map: Map) {
        name <- map["name"]
        email <- map["email"]
        avatarUrl <- map["image.url"]
        birthday <- (map["birthday"], DataTransform.date)
        genderRaw <- map["gender"]
        height <- map["height"]
        weight <- map["weight"]
        goal <- map["goal"]
        active <- map["active"]
    }
}

// MARK: Logged In User
extension User {
    class var me: User? {
        guard let userID = api.session.userID else { return nil }
        return RealmS().object(ofType: User.self, forPrimaryKey: userID)
    }
    
    static var isLogin: Bool {
        return me != nil
    }
}

enum Goals: Int {
    case beHealthier
    case loseWeight
    case gainWeight
}

enum Actives: Int {
    case sedentary
    case lightlyActive
    case modertelyActive
    case veryActive
}

// MARK: - For Nutrition
extension User {
    var age: Int {
        let now = DateInRegion(absoluteDate: Date()).year
        let birthdayYear = DateInRegion(absoluteDate: birthday).year
        return now - birthdayYear
    }

    var bmiValue: Double {
        return bmi(weight: weight, height: height)
    }

    var statusBmi: String {
        return status(bmi: bmiValue, age: age)
    }

    var caloriesToday: Double {
        guard let goal = goal, let active = active, let goals = Goals(rawValue: goal.id), let actives = Actives(rawValue: active.id) else { return 0 }
        var bmrValue = bmr(weight: weight, height: height, age: age, gender: gender)
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
