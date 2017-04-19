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
    private(set) dynamic var user: User?
    private(set) dynamic var food: Food?
    private(set) dynamic var weight: Int = 0
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
    }
}
