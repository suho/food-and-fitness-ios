//
//  SuggestionServices.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 5/24/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import RealmSwift
import RealmS
import SwiftyJSON

final class SuggestionServices {

    @discardableResult
    class func get(goalId: Int, completion: @escaping Completion) -> Request? {
        let path = ApiPath.suggestions
        let parameters: JSObject = [
            "goal_id": goalId
        ]
        return ApiManager.request(method: .get, urlString: path, parameters: parameters, completion: { (result) in
            Mapper<Suggestion>().map(result: result, type: .array, completion: completion)
        })
    }
}
