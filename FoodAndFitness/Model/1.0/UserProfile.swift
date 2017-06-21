//
//  UserProfile.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 7/26/16.
//  Copyright © 2016 SuHoVan. All rights reserved.
//

import RealmSwift
import ObjectMapper
import RealmS

enum Gender: Int, CustomStringConvertible {
    case female = 0
    case male = 1

    var description: String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        }
    }
}

final class UserProfile: Object, Mappable {
    
    private(set) dynamic var id = 0
    
    dynamic var nickname = ""
    
    private(set) dynamic var genderRaw = Gender.female.rawValue

    var gender: Gender {
        set {
            genderRaw = newValue.rawValue
        }
        get {
            let gender = Gender(rawValue: genderRaw)
            if let gender = gender {
                return gender
            } else {
                return .female
            }
        }
    }

    override class func primaryKey() -> String? {
        return "id"
    }

    convenience required init?(map: Map) {
        self.init()
        id <- map["user_id"]
    }
    
    func mapping(map: Map) {
        genderRaw <- map["gender"]
        nickname <- map["nickname"]
    }
}
