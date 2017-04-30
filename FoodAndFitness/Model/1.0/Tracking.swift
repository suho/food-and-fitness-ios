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
    private(set) dynamic var active: String = ""
    private(set) dynamic var duration: Int = 0
    private(set) dynamic var distance: Int = 0
    private(set) dynamic var userHistory: UserHistory?
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
        active <- map["active"]
        duration <- map["duration"]
        distance <- map["distance"]
        userHistory <- map["user_history"]
        createdAt <- map["created_at"]
        locations <- map["locations"]
    }
}

// MARK: - Utils
extension Tracking {
    var velocity: Double {
        return (Double(distance) / 1000) / (Double(duration) / 3600)
    }

    var caloriesBurn: Int {
        guard let userHistory = userHistory else { return 0 }
        let bmr = userHistory.caloriesToday
        let activeTracking = ActiveTracking.active(title: active)
        return caloriesBurned(bmr: bmr, velocity: velocity, active: activeTracking, duration: Double(duration) / 3600)
    }
}

// MARK: - Int
extension Int {
    var toMinutes: Int {
        return self / 60
    }
}
