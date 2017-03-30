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
        error: Error?) -> Result<JSObject> {
        guard let response = response else {
            return .failure(NSError(status: .requestTimeout))
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
            if let json = data?.toJSON() as? JSObject, let errors = json["errors"] as? JSArray, !errors.isEmpty, let message = errors[0]["value"] as? String {
                err = NSError(message: message)
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
        if let token = Session.Token(headers: response.allHeaderFields) {
            api.session.token = token
        }

        return .success(json)
    }
}

extension DataRequest {
    static func responseSerializer() -> DataResponseSerializer<JSObject> {
        return DataResponseSerializer { _, response, data, error in
            return Request.responseJSONSerializer(log: true, response: response, data: data, error: error)
        }
    }

    func responseJSON(queue: DispatchQueue? = nil, completion: @escaping (DataResponse<JSObject>) -> Void) -> Self {
        return response(responseSerializer: DataRequest.responseSerializer(), completionHandler: completion)
    }
}

enum DataType: Int {
    case object
    case array
}

extension Sequence where Iterator.Element == (key: String, value: Any) {
    func add(with key: String, value: Any) -> JSObject {
        guard var json = self as? JSObject else {
            return JSObject()
        }
        json[key] = value
        return json
    }
}

extension Array {
    func add(with key: String, value: Any) -> JSArray {
        var result = JSArray()
        for item in self {
            guard let obj = item as? JSObject else {
                return JSArray()
            }
            result.append(obj.add(with: key, value: value))
        }
        return result
    }
}

// generic type workaround
@discardableResult
private func rsmap<T: Object>(realm: RealmS, type: T.Type, json: JSObject) -> T? where T: Mappable {
    return realm.map(T.self, json: json)
}

// generic type workaround
@discardableResult
private func rsmap<T: Object>(realm: RealmS, type: T.Type, json: JSArray) -> [T] where T: Mappable {
    return realm.map(T.self, json: json)
}

extension Mapper where N: Object, N: Mappable {
    func map(result: Result<JSObject>, type: DataType, refresh: Bool = false, completion: Completion) {
        switch result {
        case .success(let json):
            guard let data = json["data"] else {
                completion(.failure(FFError.JSON))
                return
            }
            var result: Result<JSObject> = .failure(FFError.JSON)
            switch type {
            case .object:
                if let js = data as? JSObject, js.keys.isNotEmpty {
                    let realm: RealmS = RealmS()
                    realm.write {
                        rsmap(realm: realm, type: N.self, json: js)
                    }
                    result = .success(json)
                }
            case .array:
                if let js = data as? JSArray {
                    let realm = RealmS()
                    realm.write {
                        rsmap(realm: realm, type: N.self, json: js)
                    }
                    result = .success(json)
                }
            }
            completion(result)
        case .failure(_):
            completion(result)
        }
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
final class DataTransform {
    static let date = TransformOf<Date, String>(fromJSON: { (string: String?) -> Date? in
        return string?.toDate(format: .full).absoluteDate
    }, toJSON: { (date: Date?) -> String? in
        return date?.ffDate(format: .date).toString(format: .date)
    })

    static let dateTime = TransformOf<Date, String>(fromJSON: { (string: String?) -> Date? in
        return string?.toDate(format: .dateTime).absoluteDate
    }, toJSON: { (date: Date?) -> String? in
        return date?.ffDate(format: .dateTime).toString(format: .dateTime)
    })
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
