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

    var userExerciseId: Int

    init(userExerciseId: Int) {
        self.userExerciseId = userExerciseId
    }

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

    @discardableResult
    func delete(completion: @escaping Completion) -> Request? {
        let path = ApiPath.UserExercise(id: userExerciseId).delete
        return ApiManager.request(method: .delete, urlString: path, completion: { (result) in
            switch result {
            case .success(let value):
                let realm = RealmS()
                if let userExercise = realm.object(ofType: UserExercise.self, forPrimaryKey: self.userExerciseId) {
                    realm.write {
                        realm.delete(userExercise)
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
