//
//  ApiMananger.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/7/16.
//  Copyright © 2016 SuHoVan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftUtils
import RealmSwift
import RealmS

typealias JSObject = [String: Any]
typealias JSArray = [JSObject]
typealias Completion = (Result<JSObject>) -> Void

let api: ApiManager = ApiManager()

final class ApiManager {
    let session = Session()

    var defaultHTTPHeaders: [String: String] {
        var headers: [String: String] = [:]
        if let token = session.token {
            headers.updateValues(token.values)
        }
        return headers
    }

    private func cleanDatabase() {
        let realm = RealmS()
        realm.write {
            realm.deleteAll()
        }
        logger.info("Database cleaned!")
    }

    func logout() {
        cleanDatabase()
        session.reset()
    }
}
