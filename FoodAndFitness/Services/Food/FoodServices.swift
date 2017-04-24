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

    var userFoodId: Int

    init(userFoodId: Int) {
        self.userFoodId = userFoodId
    }

    @discardableResult
    class func save(params: UserFoodParams, completion: @escaping Completion) -> Request? {
        let path = ApiPath.userFoods
        let parameters: JSObject = [
            "food_id": params.foodId,
            "weight": params.weight,
            "meal": params.meal
        ]
        return ApiManager.request(method: .post, urlString: path, parameters: parameters, completion: { (result) in
            Mapper<UserFood>().map(result: result, type: .object, completion: completion)
        })
    }

    @discardableResult
    func delete(completion: @escaping Completion) -> Request? {
        let path = ApiPath.UserFood(id: userFoodId).delete
        return ApiManager.request(method: .delete, urlString: path, completion: { (result) in
            switch result {
            case .success(let value):
                let realm = RealmS()
                if let userFood = realm.object(ofType: UserFood.self, forPrimaryKey: self.userFoodId) {
                    realm.write {
                        realm.delete(userFood)
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
