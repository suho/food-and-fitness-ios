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
    func update(params: UpdateParams, completion: @escaping Completion) -> Request? {
        let path = ApiPath.Auth.auth
        var parameters: JSObject!
        if let weight = params.weight {
            parameters = [
                "weight": weight
            ]
        } else {
            parameters = [
                "height": params.height.toString()
            ]
        }
        return ApiManager.request(method: .put, urlString: path, parameters: parameters, completion: { (result) in
            Mapper<User>().map(result: result, type: .object, completion: completion)
        })
    }

    @discardableResult
    class func signIn(params: SignInParams, completion: @escaping Completion) -> Request? {
        let path = ApiPath.Auth.auth
        let parameters: JSObject = [
            "email": params.email,
            "password": params.password
        ]
        return ApiManager.request(method: .post, urlString: path, parameters: parameters, completion: { (result) in
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
                api.session.credential = Session.Credential(username: params.email, password: params.password)
            case .failure(_): break
            }
            completion(result)
        })
    }

    @discardableResult
    class func signUp(params: SignUpParams, completion: @escaping Completion) -> Request? {
        let path = ApiPath.Auth.auth
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

    class func upload(image: UIImage, completion: @escaping Completion) {
        let path = ApiPath.User.upload
        guard let url = URL(string: path) else {
            let error = NSError(message: Strings.Errors.urlError)
            completion(.failure(error))
            return
        }
        guard let data = UIImageJPEGRepresentation(image, 1) else {
            let error = NSError(message: Strings.Errors.emptyImage)
            completion(.failure(error))
            return
        }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "PUT"
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.addHeaders(boundary: boundary)
        request.httpBody(key: "file", value: data, boundary: boundary)
        let queue = DispatchQueue(label: "uploadImage", qos: .background, attributes: .concurrent)
        queue.async {
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, _, error) -> Void in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                guard let data = data else { return }
                guard let json = data.toJSON() as? JSObject else {
                    DispatchQueue.main.async {
                        completion(.failure(FFError.json))
                    }
                    return
                }
                DispatchQueue.main.async {
                    Mapper<User>().map(result: .success(json), type: .object, completion: completion)
                }
            })
            task.resume()
        }
    }
}
