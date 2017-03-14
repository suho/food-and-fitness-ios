//
//  ApiPath.swift
//  CM
//
//  Created by DaoNV on 3/7/16.
//  Copyright © 2016 AsianTech Inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftDate

private protocol URLStringConvertible {
    var URLString: String { get }
}

class ApiPath {

    #if RELEASE
        static var baseURL = "https://apis-ssl.unit-hosting.com/rideshare/develop/api/v1"
        static var googleBaseURL = "https://maps.googleapis.com/maps/api/"
    #else
        static var baseURL = "https://apis-ssl.unit-hosting.com/rideshare/develop/api/v1"
        static var googleBaseURL = "https://maps.googleapis.com/maps/api/"
    #endif

    static var isPro: Bool {
        return baseURL == "https://api.asiantech.vn/api/v2"
    }

    // MARK: - Roots
    static var users: String { return baseURL / "users" }
    static var images: String { return baseURL / "images" }
    static var htmlFAQ: String { return baseURL / "faq" }
    static var htmlPolicy: String { return baseURL / "policy" }
    static var htmlTermsOfUse: String { return baseURL / "rule" }
    static var htmlAboutCompany: String { return baseURL / "about-company" }
    private static var auth: String { return baseURL / "auth" }
    static var offers: String { return baseURL / "offers" }
    static var locations: String { return baseURL / "locations" }
    static var cars: String { return baseURL / "car_types" }

    struct Auth {
        static var login: String {
            return ApiPath.auth / "sign_in"
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

        static var me: String { return ApiPath.users / "me" }

        static var notifications: String { return ApiPath.users / "me" / "push-settings" }
    }

    struct Google: URLStringConvertible {
        var URLString: String {
            return ApiPath.googleBaseURL
        }

        static var placeAutoComplete: String {
            return ApiPath.googleBaseURL / "place" / "autocomplete" / "json"
        }

        static var directions: String {
            return ApiPath.googleBaseURL / "directions" / "json"
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
