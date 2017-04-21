//
//  Tracking.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/9/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import RealmSwift
import ObjectMapper
import RealmS

final class Tracking: Object, Mappable {

    private(set) dynamic var id = 0
    private(set) dynamic var name: String = ""
    private(set) dynamic var startTime: Date = Date()
    private(set) dynamic var duration: Int = 0
    private(set) dynamic var distance: Int = 0
    private(set) dynamic var calories: Int = 0
    private(set) dynamic var user: User?
    private(set) dynamic var createdAt: Date = Date()
    let locations = List<Location>()

    override class func primaryKey() -> String? {
        return "id"
    }

    convenience required init?(map: Map) {
        self.init()
        id <- map["id"]
        assert(id > 0, "Tracking `id` must be greater than 0")
    }

    func mapping(map: Map) {
    }
}
