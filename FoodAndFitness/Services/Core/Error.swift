//
//  Error.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/7/16.
//  Copyright © 2016 SuHoVan. All rights reserved.
//

import Foundation
import SwiftUtils
import Alamofire

// MARK: - NetworkReachabilityManager
extension NetworkReachabilityManager {
    static let sharedInstance: NetworkReachabilityManager! = NetworkReachabilityManager()
}

class RSError {
    static let Network = NSError(domain: ApiPath.baseURL.host, status: HTTPStatus.requestTimeout, message: Strings.Errors.notNetwork)
    static let Authentication = NSError(domain: ApiPath.baseURL.host, status: HTTPStatus.unauthorized)
    static let JSON = NSError(domain: NSCocoaErrorDomain, code: 3840, message: Strings.Errors.json)
    static let ApiKey = NSError(domain: ApiPath.baseURL.host, code: 120, message: "")

    static var isNetworkError: Bool {
        return NetworkReachabilityManager.sharedInstance.isReachable == false
    }

    static func fatal(message: String) {
        let error = NSError(message: message)
        logger.error(error)
        let msg = message + "\nYou must restart this application.\nThanks you!"
        DispatchQueue.main.async {
            let alert = AlertController(title: App.name, message: msg, preferredStyle: .alert)
            alert.level = .require
            alert.present()
        }
    }

    static func assert(condition: Bool, _ message: String) {
        guard !condition else { return }
        let error = NSError(message: message)
            DispatchQueue.main.async {
                AlertController.alertWithError(error, level: .require, handler: nil).present()
            }
    }
}

extension NSError {
    func show(level: AlertLevel = .normal) {
        // check errors global
        if let status = HTTPStatus(code: self.code) {
            switch status {
            case .serviceUnavailable:
                break
            case .noResponse:
                let error = NSError(message: Strings.Errors.appUpdate)
                AlertController.alertWithError(error, level: level, handler: {
                    guard let url = App.storeLink.url else { return }
                    UIApplication.shared.openURL(url)
                }).present()
            default: break
            }
        } else {
            // erros normal
            AlertController.alertWithError(self, level: level, handler: nil).present()
        }
    }
}
