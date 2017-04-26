//
//  Location.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/9/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import RealmSwift
import ObjectMapper
import RealmS
import CoreLocation

final class Location: Object, Mappable {

    private(set) dynamic var id = 0
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0

    override class func primaryKey() -> String? {
        return "id"
    }

    convenience required init?(map: Map) {
        self.init()
        id <- map["id"]
        assert(id > 0, "Location `id` must be greater than 0")
    }

    func mapping(map: Map) {
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
}

// MARK: - Utils
extension Location {
    var toCLLocation: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

// MARK: - CLLocation
extension CLLocation {
    var toLocation: Location {
        let location = Location()
        location.latitude = self.coordinate.latitude
        location.longitude = self.coordinate.longitude
        return location
    }
}

// MARK: - Array
extension Array where Element: Location {
    func toJSObject() -> [JSObject] {
        var array: [JSObject] = []
        for location in self {
            let json: JSObject = [
                "latitude": location.latitude,
                "longitude": location.longitude
            ]
            array.append(json)
        }
        return array
    }
}
