//
//  ExerciseServices.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/24/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import RealmSwift
import RealmS
import SwiftyJSON

final class ExerciseServices {

    @discardableResult
    class func save(params: UserExerciseParams, completion: @escaping Completion) -> Request? {
        let path = ApiPath.userExercises
        let parameters: JSObject = [
            "exercise_id": params.exerciseId,
            "duration": params.duration
        ]
        return ApiManager.request(method: .post, urlString: path, parameters: parameters, completion: { (result) in
            Mapper<UserExercise>().map(result: result, type: .object, completion: completion)
        })
    }
}
