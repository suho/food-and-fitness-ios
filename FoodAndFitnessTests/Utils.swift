//
//  Utils.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 6/21/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//
import Alamofire
import RealmSwift
import ObjectMapper
import RealmS

struct Timeout {
    static var forRequest: TimeInterval {
        return Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest
    }

    static var forResource: TimeInterval {
        return Alamofire.SessionManager.default.session.configuration.timeoutIntervalForResource
    }
}
