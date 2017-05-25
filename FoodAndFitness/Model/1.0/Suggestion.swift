//
//  Suggestion.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 5/24/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import RealmSwift
import ObjectMapper
import RealmS

final class Suggestion: Object, Mappable {

    dynamic var id = 0
    dynamic var breakfast: String = ""
    dynamic var lunch: String = ""
    dynamic var dinner: String = ""
    dynamic var exercise: String = ""
    private(set) dynamic var goal: Goal?

    override class func primaryKey() -> String? {
        return "id"
    }

    convenience required init?(map: Map) {
        self.init()
        id <- map["id"]
        assert(id > 0, "Suggestion `id` must be greater than 0")
    }

    func mapping(map: Map) {
        breakfast <- map["breakfast"]
        lunch <- map["lunch"]
        dinner <- map["dinner"]
        exercise <- map["exercise"]
        goal <- map["goal"]
    }
}
