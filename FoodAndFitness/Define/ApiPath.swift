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

    struct Auth {
        static var signin: String {
            return ApiPath.auth / "sign_in"
        }

        static var signup: String {
            return ApiPath.auth
        }
    }

    struct User: URLStringConvertible {
        var userID: Int

        init(userID: Int) {
            self.userID = userID
        }

        var URLString: String {
            return ApiPath.users / userID
        }

        static var upload: String { return ApiPath.baseURL / "avatars" / "upload" }

        static var me: String { return ApiPath.users / "me" }

        static var notifications: String { return ApiPath.users / "me" / "push-settings" }
    }

    struct Google: URLStringConvertible {
        var URLString: String {
            return ApiPath.googleMapURL
        }

        static var placeAutoComplete: String {
            return ApiPath.googleMapURL / "place" / "autocomplete" / "json"
        }

        static var directions: String {
            return ApiPath.googleMapURL / "directions" / "json"
        }

        static var componentsCountry: String {
            return "country:jp"
        }
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
