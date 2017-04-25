//
//  TrackingServices.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/25/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import RealmSwift
import RealmS
import SwiftyJSON

final class TrackingServices {

    @discardableResult
    class func save(params: TrackingParams, completion: @escaping Completion) -> Request? {
        let path = ApiPath.trackings
        let parameters: JSObject = [
            "active": params.active,
            "duration": params.duration,
            "distance": params.distance,
            "velocity": params.velocity,
            "locations_attributes": params.locations.toValue()
        ]
        return ApiManager.request(method: .post, urlString: path, parameters: parameters, completion: { (result) in
            Mapper<Tracking>().map(result: result, type: .object, completion: completion)
        })
    }
}
