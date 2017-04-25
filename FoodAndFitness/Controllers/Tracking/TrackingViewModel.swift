//
//  TrackingViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/25/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import RealmSwift
import RealmS
import CoreLocation

//{
//    "active": "running",
//    "duration": 3600,
//    "distance": 3000,
//    "velocity": 1,
//    "user_id": 1,
//    "locations_attributes": [{
//    "latitude": 2,
//    "longitude": 3
//    },
//    {
//    "latitude": 1,
//    "longitude": 2
//    },
//    {
//    "latitude": 1,
//    "longitude": 2
//    }]
//}

struct TrackingParams {
    var active: String
    var duration: Int
    var distance: Int
    var velocity: Double
    var locations: [Location]
}

class TrackingViewModel {
    
    var active: ChooseActiveTrackingController.ActiveTracking = .walking
    var locations: [CLLocation] = [CLLocation]()
    var seconds: Double = 0.0
    var distance: Double = 0.0

    func save(duration: Int, completion: @escaping Completion) {
        if User.me == nil {
            let error = NSError(message: Strings.Errors.tokenError)
            completion(.failure(error))
        } else {
            let velocity = distance / seconds
            let params = TrackingParams(active: active.title, duration: Int(seconds), distance: Int(distance), velocity: velocity, locations: locations.map({ (clLocation) -> Location in
                return clLocation.toLocation
            }))
            TrackingServices.save(params: params, completion: completion)
        }
    }
}
