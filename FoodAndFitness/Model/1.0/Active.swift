//
//  Active.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/9/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import RealmSwift
import ObjectMapper
import RealmS

final class Active: Object, Mappable {

    dynamic var id = 0
    dynamic var name: String = ""
    dynamic var detail: String = ""

    override class func primaryKey() -> String? {
        return "id"
    }

    convenience required init?(map: Map) {
        self.init()
        id <- map["id"]
        assert(id > 0, "Active `id` must be greater than 0")
    }

    func mapping(map: Map) {
        name <- map["name"]
        detail <- map["detail"]
    }
}
