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
typealias Completion = (Result<Any>) -> Void
typealias ViewModelCompletion = (_ success: Bool, _ error: Error?) -> Void

let api: ApiManager = ApiManager()

class ApiManager {
    let session = Session()

    var defaultHTTPHeaders: [String: String] {
        var headers: [String: String] = [:]
        if let headerToken = session.headerToken {
            headers["access-token"] = headerToken.accessToken
        }

        return headers
    }
    
    /// Invalidate Realm and delete all objects.
    private func cleanDatabase() {
        let realm = RealmS()
        realm.write {
            realm.deleteAll()
        }
        logger.info("Database cleaned!")
    }
}
