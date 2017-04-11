//
//  Food.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/9/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import RealmSwift
import ObjectMapper
import RealmS

final class Food: Object, Mappable {

    private(set) dynamic var id = 0
    private(set) dynamic var name: String = ""
    private(set) dynamic var weight: Int = 0
    private(set) dynamic var calories: Int = 0
    private(set) dynamic var protein: Int = 0
    private(set) dynamic var carbs: Int = 0
    private(set) dynamic var fat: Int = 0

    override class func primaryKey() -> String? {
        return "id"
    }

    convenience required init?(map: Map) {
        self.init()
        id <- map["id"]
        assert(id > 0, "Food `id` must be greater than 0")
    }

    func mapping(map: Map) {
    }
}
