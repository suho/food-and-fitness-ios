//
//  Mapper.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/5/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import RealmSwift
import RealmS

enum DataType: Int {
    case object
    case array
}

// generic type workaround
@discardableResult
private func ffmap<T: Object>(realm: RealmS, type: T.Type, json: JSObject) -> T? where T: Mappable {
    return realm.map(T.self, json: json)
}

// generic type workaround
@discardableResult
private func ffmap<T: Object>(realm: RealmS, type: T.Type, json: JSArray) -> [T] where T: Mappable {
    return realm.map(T.self, json: json)
}

extension Mapper where N: Object, N: Mappable {
    func map(result: Result<JSObject>, type: DataType, completion: Completion) {
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
                        ffmap(realm: realm, type: N.self, json: js)
                    }
                    result = .success(json)
                }
            case .array:
                if let js = data as? JSArray {
                    let realm = RealmS()
                    realm.write {
                        ffmap(realm: realm, type: N.self, json: js)
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

// MARK: Data Transform
final class DataTransform {
    static let date = TransformOf<Date, String>(fromJSON: { (string: String?) -> Date? in
        return string?.toDate(format: .date).absoluteDate
    }, toJSON: { (date: Date?) -> String? in
        return date?.ffDate(format: .date).toString(format: .date)
    })

    static let dateTime = TransformOf<Date, String>(fromJSON: { (string: String?) -> Date? in
        return string?.toDate(format: .dateTime).absoluteDate
    }, toJSON: { (date: Date?) -> String? in
        return date?.ffDate(format: .dateTime).toString(format: .dateTime)
    })
}
