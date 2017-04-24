//
//  ApiPath.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/7/16.
//  Copyright © 2016 SuHoVan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftDate

private protocol URLStringConvertible {
    var URLString: String { get }
}

final class ApiPath {

    static var baseURL = "http://localhost:3000"

    static var googleMapURL = "https://maps.googleapis.com/maps/api/"

    // MARK: - Roots
    private static var auth: String { return baseURL / "auth" }
    static var users: String { return baseURL / "users" }
    static var foods: String { return baseURL / "foods" }
    static var exercises: String { return baseURL / "exercises" }
    static var userFoods: String { return baseURL / "user_foods" }
    static var userExercises: String { return baseURL / "user_exercises" }

    struct Auth {
        static var signin: String {
            return ApiPath.auth / "sign_in"
        }

        static var signup: String {
            return ApiPath.auth
        }
    }

    struct Food {
        var foodId: Int

        init(foodId: Int) {
            self.foodId = foodId
        }
    }

    struct User {
        var userID: Int

        init(userID: Int) {
            self.userID = userID
        }

        static var upload: String { return ApiPath.baseURL / "avatars" / "upload" }
    }
}

private func / (lhs: String, rhs: String) -> String {
    return lhs.append(path: rhs)
}

private func / (lhs: String, rhs: URLStringConvertible) -> String {
    return lhs.append(path: rhs.URLString)
}

private func / (lhs: URLStringConvertible, rhs: String) -> String {
    return lhs.URLString.append(path: rhs)
}

private func / (lhs: URLStringConvertible, rhs: URLStringConvertible) -> String {
    return lhs.URLString.append(path: rhs.URLString)
}

private func / (lhs: String, rhs: Int) -> String {
    return lhs.append(path: "\(rhs)")
}

private func / (lhs: URLStringConvertible, rhs: Int) -> String {
    return lhs.URLString.append(path: "\(rhs)")
}

extension String {
    public func append(path: String) -> String {
        let set = NSCharacterSet(charactersIn: "/")
        let left = trimmedRight(characterSet: set as CharacterSet)
        let right = path.trimmed(characterSet: set as CharacterSet)
        return left + "/" + right
    }
}
