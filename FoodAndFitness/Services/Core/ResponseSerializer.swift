//
//  ResponseSerializer.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/7/16.
//  Copyright © 2016 SuHoVan. All rights reserved.
//

import Alamofire
import SwiftUtils
import RealmSwift
import ObjectMapper
import RealmS
import SwiftyJSON
extension Request {
    static func responseJSONSerializer(
                                       log: Bool = true,
                                       response: HTTPURLResponse?,
                                       data: Data?,
                                       error: Error?) -> Result<Any> {
        guard let response = response else {
            return .failure(NSError(status: .noResponse))
        }
        
        logger.info("\n response -> \(response)") // URL response

        if let error = error {
            return .failure(error)
        }
        
        let statusCode = response.statusCode

        if 204...205 ~= statusCode { // empty data status code
            return .success([:])
        }

        guard 200...299 ~= statusCode else {
            var err: NSError!
            if let json = data?.toJSON() as? JSObject, let message = json["message"] as? String {
                err = NSError(domain: ApiPath.baseURL.host,
                              code: statusCode,
                              message: message)
            } else if let status = HTTPStatus(code: statusCode) {
                err = NSError(domain: ApiPath.baseURL.host, status: status)
            } else {
                err = NSError(domain: ApiPath.baseURL.host,
                              code: statusCode,
                              message: "Unknown HTTP status code received (\(statusCode)).")
            }

            return .failure(err)
        }

        guard let data = data, let json = data.toJSON() as? JSObject else {
            return Result.failure(RSError.JSON)
        }

        logger.info("\n data -> \(json)")

        let allHeaderFields = JSON(response.allHeaderFields)
        if let accessToken = allHeaderFields["access-token"].string, let client = allHeaderFields["client"].string, let uid = allHeaderFields["uid"].string {
            // save header token
            api.session.headerToken = Session.HeaderToken(accessToken: accessToken, clientId: client, uid: uid)
        }

        return .success(json)
    }
}

extension DataRequest {
    static func responseSerializer() -> DataResponseSerializer<Any> {
        return DataResponseSerializer { _, response, data, error in
            return Request.responseJSONSerializer(log: true, response: response, data: data, error: error)
        }
    }

    func responseJSON(queue: DispatchQueue? = nil, completion: @escaping (DataResponse<Any>) -> Void) -> Self {
        return response(responseSerializer: DataRequest.responseSerializer(), completionHandler: completion)
    }
}

enum DataType: Int {
    case object
    case array
}

extension Mapper where N: Object {
    func map(jsonData: Any, type: DataType, completion: Completion) {
        switch type {
        case .object:
            if let jsonObject = (jsonData as? JSObject), jsonObject.keys.isNotEmpty, let obj: N = Mapper<N>().map(JSON: jsonObject) {
                let realm = RealmS()
                realm.write {
                    realm.add(obj)
                }
                completion(.success(obj))
                return
            }
        case .array:
            if let jsonArray = (jsonData as? JSArray), jsonArray.isNotEmpty {
                let realm = RealmS()
                realm.write {
                    if let array: [N] = Mapper<N>().mapArray(JSONArray: jsonArray) {
                        for item in array {
                            realm.add(item)

                        }
                        completion(.success(array))
                    }
                }
                return
            }
        }

        completion(.success(jsonData))
    }
}
