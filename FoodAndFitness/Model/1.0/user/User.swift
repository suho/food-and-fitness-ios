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
    private(set) dynamic var name: String = ""
    private(set) dynamic var email: String = ""
    private(set) dynamic var avatarUrl: String = ""
    private(set) dynamic var birthday: Date = Date(timeIntervalSince1970: 0)
    private(set) dynamic var genderRaw = Gender.others.rawValue
    private(set) dynamic var height: Int = 0
    private(set) dynamic var weight: Int = 0
    private(set) dynamic var goal: Goal?
    private(set) dynamic var active: Active?

    var gender: Gender {
        set {
            genderRaw = newValue.rawValue
        }
        get {
            let gender = Gender(rawValue: genderRaw)
            if let gender = gender {
                return gender
            } else {
                return .others
            }
        }
    }

    override class func primaryKey() -> String? {
        return "id"
    }

    convenience required init?(map: Map) {
        self.init()
        id <- map["id"]
        assert(id > 0, "User `id` must be greater than 0")
    }

    func mapping(map: Map) {

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
