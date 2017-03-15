//
//  User.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 6/19/16.
//  Copyright © 2016 SuHoVan. All rights reserved.
//

import RealmSwift
import ObjectMapper
import RealmS

final class User: Object, Mappable {

    private(set) dynamic var id = 0
    dynamic var name: String?
    private(set) dynamic var email: String?
    private(set) dynamic var standardUrl: String?
    private(set) dynamic var thumbUrl: String?
    private(set) dynamic var userCode: String?

    override class func primaryKey() -> String? {
        return "id"
    }

    convenience required init?(map: Map) {
        self.init()
        id <- map["id"]
        assert(id > 0, "`id` must be greater than 0")
    }

    func mapping(map: Map) {
        name <- map["name"]
        email <- map["email"]
        userCode <- map["user_code"]
    }
}

// MARK: Logged In User
extension User {
    class var me: User? {
        guard let userID = api.session.userID else { return nil }
        return RealmS().object(ofType: User.self, forPrimaryKey: userID)
    }
    
    static var isLogin: Bool {
        return me != nil
    }
}
