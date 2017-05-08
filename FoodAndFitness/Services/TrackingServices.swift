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

    var trackingId: Int

    init(trackingId: Int) {
        self.trackingId = trackingId
    }

    @discardableResult
    class func get(completion: @escaping Completion) -> Request? {
        let path = ApiPath.trackings
        return ApiManager.request(method: .get, urlString: path, completion: { (result) in
            Mapper<Tracking>().map(result: result, type: .array, completion: completion)
        })
    }

    @discardableResult
    class func save(params: TrackingParams, completion: @escaping Completion) -> Request? {
        let path = ApiPath.trackings
        let parameters: JSObject = [
            "active": params.active,
            "duration": params.duration,
            "distance": params.distance,
            "locations_attributes": params.locations.toJSObject()
        ]
        return ApiManager.request(method: .post, urlString: path, parameters: parameters, completion: { (result) in
            Mapper<Tracking>().map(result: result, type: .object, completion: completion)
        })
    }

    @discardableResult
    func delete(completion: @escaping Completion) -> Request? {
        let path = ApiPath.Tracking(id: trackingId).delete
        return ApiManager.request(method: .delete, urlString: path, completion: { (result) in
            switch result {
            case .success(let value):
                let realm = RealmS()
                if let tracking = realm.object(ofType: Tracking.self, forPrimaryKey: self.trackingId) {
                    realm.write {
                        realm.delete(tracking)
                        completion(.success(value))
                    }
                } else {
                    completion(.failure(FFError.json))
                }
            case .failure(_):
                completion(result)
            }
        })
    }
}
