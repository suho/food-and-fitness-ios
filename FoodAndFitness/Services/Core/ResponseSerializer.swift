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
            return Result.failure(FFError.JSON)
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

    func map(jsonData: Any, type: DataType, inKey: String, refresh: Bool = false, completion: Completion) {
        switch type {
        case .object:
            if let jsonObject = (jsonData as AnyObject)[inKey] as? JSObject {
                map(jsonData: jsonObject, type: type, refresh: refresh, completion: completion)
                return
            }
        case .array:
            if let jsonArray = (jsonData as AnyObject)[inKey] as? JSArray {
                map(jsonData: jsonArray, type: type, refresh: refresh, completion: completion)
                return
            }
        }

        completion(.failure(FFError.JSON))
    }

    func map(jsonData: Any, type: DataType, refresh: Bool = false, completion: Completion) {
        if refresh {
            // clean objects in database
            let realm = RealmS()
            realm.write {
                realm.delete(realm.objects(N.self))
            }
        }

        var result: Result<Any> = .failure(FFError.JSON)
        switch type {
        case .object:
            if let jsonObject = (jsonData as? JSObject), jsonObject.keys.isNotEmpty {
                let realm = RealmS()
                realm.write {
                    if let obj: N = Mapper<N>().map(JSON: jsonObject) {
                        realm.add(obj)
                        result = .success(obj)
                    }
                }
            }
        case .array:
            if let jsonArray = (jsonData as? JSArray) {
                let realm = RealmS()
                realm.write {
                    if let array: [N] = Mapper<N>().mapArray(JSONArray: jsonArray) {
                        for item in array {
                            realm.add(item)
                        }
                        result = .success(array)
                    }
                }
            }
        }

        completion(result)
    }
}

final class Meta: Mappable {
    var currentPage = 0
    var nextPage = 0
    var prevPage = 0
    var totalCount = 0
    var totalPages = 0

    init() { }

    init(map: Map) { }

    func mapping(map: Map) {
        currentPage <- map["current_page"]
        nextPage <- map["next_page"]
        prevPage <- map["prev_page"]
        totalCount <- map["total_count"]
        totalPages <- map["total_pages"]
    }

    private func getPage(fromUrl url: String) -> Int {
        guard let page = url.components(separatedBy: "=").last else { return 0 }
        return page.intValue
    }
}

// MARK: - Extract `next_page_url` from response
extension Result {
    var meta: Meta {
        let meta = Meta()
        switch self {
        case .success(let value):
            if let json = (value as AnyObject)["meta"] as? JSObject {
                return Mapper<Meta>().map(JSON: json, toObject: meta)
            }
        default: break
        }
        return meta
    }
}

// MARK: Data Transform
class DataTransform {
    static let date = TransformOf<Date, String>(
                                                fromJSON: { (string: String?) -> Date in
        if let result = string?.toDate(format: .full).absoluteDate {
            return result
        }
        return Foundation.Date.null
    }, toJSON: { (date: Date?) -> String? in
        return date?.ffDate(format: .date).toString(format: .date)
    }
    )

    static let dateTime = TransformOf<Date, String>(
                                                    fromJSON: { (string: String?) -> Date? in
        if let result = string?.toDate(format: .dateTime).absoluteDate {
            return result
        }
        return Foundation.Date.null
    }, toJSON: { (date: Date?) -> String? in
        return date?.ffDate(format: .dateTime).toString(format: .dateTime)
    }
    )
}

func <- ( left: inout String, right: Map) {
    var str: String? = left
    str <- right
    if right.mappingType == .fromJSON {
        if let str = str {
            left = str
        } else {
            left = ""
        }
    }
}

func <- ( left: inout Int, right: Map) {
    var value: Int? = left
    value <- right
    if right.mappingType == .fromJSON {
        if let value = value {
            left = value
        } else {
            left = 0
        }
    }
}

func <- ( left: inout Float, right: Map) {
    var value: Float? = left
    value <- right
    if right.mappingType == .fromJSON {
        if let value = value {
            left = value
        } else {
            left = 0.0
        }
    }
}

func <- ( left: inout Double, right: Map) {
    var value: Double? = left
    value <- right
    if right.mappingType == .fromJSON {
        if let value = value {
            left = value
        } else {
            left = 0.0
        }
    }
}

func <- ( left: inout Bool, right: Map) {
    var value: Bool? = left
    value <- right
    if right.mappingType == .fromJSON {
        if let value = value {
            left = value
        } else {
            left = false
        }
    }
}
