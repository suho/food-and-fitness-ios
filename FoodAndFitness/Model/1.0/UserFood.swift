//
//  UserFood.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/9/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import RealmSwift
import ObjectMapper
import RealmS

final class UserFood: Object, Mappable {

    private(set) dynamic var id = 0
    dynamic var userHistory: UserHistory?
    dynamic var food: Food?
    dynamic var weight: Int = 0
    dynamic var meal: String = ""
    dynamic var createdAt: Date = Date()

    override class func primaryKey() -> String? {
        return "id"
    }

    convenience required init?(map: Map) {
        self.init()
        id <- map["id"]
        assert(id > 0, "UserFood `id` must be greater than 0")
    }

    func mapping(map: Map) {
        food <- map["food"]
        userHistory <- map["user"]
        weight <- map["weight"]
        createdAt <- map["created_at"]
        meal <- map["meal"]
    }
}

// MARK: - Utils
extension UserFood {
    fileprivate var ratio: Double {
        guard let food = food else { return 1 }
        return Double(weight) / Double(food.weight)
    }
    var calories: Int {
        guard let food = food else { return 0 }
        let calories = ratio * Double(food.calories)
        return Int(calories)
    }

    var protein: Int {
        guard let food = food else { return 0 }
        let protein = ratio * Double(food.protein)
        return Int(protein)
    }

    var carbs: Int {
        guard let food = food else { return 0 }
        let carbs = ratio * Double(food.carbs)
        return Int(carbs)
    }

    var fat: Int {
        guard let food = food else { return 0 }
        let fat = ratio * Double(food.fat)
        return Int(fat)
    }
}
