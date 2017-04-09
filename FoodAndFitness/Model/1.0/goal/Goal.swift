//
//  Goal.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/9/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import RealmSwift
import ObjectMapper
import RealmS

final class Goal: Object, Mappable {

    private(set) dynamic var id = 0
    private(set) dynamic var name: String = ""
    private(set) dynamic var detail: String = ""

    override class func primaryKey() -> String? {
        return "id"
    }

    convenience required init?(map: Map) {
        self.init()
        id <- map["id"]
        assert(id > 0, "User `id` must be greater than 0")
    }

    func mapping(map: Map) {
    }
}
