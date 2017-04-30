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
        createdAt <- map["created_at"]
    }
}

// MARK: - Utils
extension UserHistory {}
