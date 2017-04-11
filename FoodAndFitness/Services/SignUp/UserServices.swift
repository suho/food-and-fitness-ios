//
//  UserServices.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/11/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import RealmSwift
import RealmS
import SwiftyJSON

final class UserServices {

    @discardableResult
    class func uplpad() -> Request? {
        return nil
    }

    @discardableResult
    class func signUp(params: SignUpParams, completion: @escaping Completion) -> Request? {
        let path = ApiPath.Auth.signup
        var parameter: JSObject = [
            "email": params.email.toString(),
            "password": params.password.toString(),
            "name": params.fullName.toString(),
            "birthday": params.birthday.toString(),
            "gender": params.gender,
            "height": params.height.toString(),
            "weight": params.weight.toString()
        ]
        if let goal = params.goal {
            parameter["goal_id"] = goal.id
        }
        if let active = params.active {
            parameter["active_id"] = active.id
        }
        return ApiManager.request(method: .post, urlString: path, parameters: parameter, completion: { (result) in
            switch result {
            case .success(let json):
                guard let json = json["data"] as? JSObject else {
                    completion(.failure(FFError.json))
                    return
                }
                let realm = RealmS()
                var userId: Int?
                realm.write {
                    if let user = realm.map(User.self, json: json) {
                        userId = user.id
                    }
                }
                guard let id = userId else {
                    completion(.failure(FFError.json))
                    return
                }
                api.session.userID = id
                api.session.credential = Session.Credential(username: params.email.toString(), password: params.password.toString())
            case .failure(_): break
            }
            completion(result)
        })
    }
}
