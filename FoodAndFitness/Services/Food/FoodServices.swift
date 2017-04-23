//
//  FoodServices.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/23/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import RealmSwift
import RealmS
import SwiftyJSON

final class FoodServices {

    @discardableResult
    class func save(params: UserFoodParams, completion: @escaping Completion) -> Request? {
        let path = ApiPath.userFoods
        let parameters: JSObject = [
            "food_id": params.foodId,
            "user_id": params.userId,
            "weight": params.weight,
            "meal": params.meal
        ]
        return ApiManager.request(method: .post, urlString: path, parameters: parameters, completion: { (result) in
            Mapper<UserFood>().map(result: result, type: .object, completion: completion)
        })
    }
}
