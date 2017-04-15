//
//  ConfigServices.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/15/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import RealmSwift
import RealmS
import SwiftyJSON

final class ConfigServices {

    @discardableResult
    class func getFoods(completion: @escaping Completion) -> Request? {
        let path = ApiPath.foods
        return ApiManager.request(method: .get, urlString: path, completion: { (result) in
            Mapper<Food>().map(result: result, type: .array, completion: completion)
        })
    }
}
