//
//  RequestSerializer.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 7/8/16.
//  Copyright © 2016 SuHoVan. All rights reserved.
//

import Alamofire
import SwiftUtils
import Foundation

extension ApiManager {
    class func request(method: HTTPMethod,
                       urlString: String,
                       parameters: [String: Any]? = nil,
                       headers: [String: String]? = nil,
                       completion: Completion?) -> Request? {
        guard Network.shared.isReachable else {
            completion?(.failure(FFError.Network))
            return nil
        }

        logger.debug("\n url -> \(urlString)")
        logger.debug("\n headers -> \(headers)")
        logger.debug("\n parameters -> \(parameters)\n")

        var encoding: ParameterEncoding = URLEncoding.default

        if method == .post {
            encoding = JSONEncoding.default
        }

        var _headers = api.defaultHTTPHeaders
        _headers.updateValues(headers)

        let request = Alamofire.request(urlString, method: method, parameters: parameters, encoding: encoding, headers: _headers)
        _ = request.validate().responseJSON(completion: { (response) in
            completion?(response.result)
        })
        return request
    }}
