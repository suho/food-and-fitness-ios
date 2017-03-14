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

private let clientIdPro: String = {
    let chars: [String] = [
        "6", "0", "2", "d", "c", "3", "9", "d",
        "0", "f", "8", "9", "f", "4", "d", "e",
        "c", "1", "6", "6", "1", "f", "1", "1",
        "a", "9", "6", "a", "8", "5", "f", "2",
        "0", "2", "7", "6", "8", "9", "b", "6",
        "c", "4", "5", "7", "2", "d", "6", "b",
        "f", "9", "1", "c", "9", "7", "a", "2",
        "a", "5", "8", "b", "2", "2", "c", "0"
    ]
    return chars.joined(separator: "")
}()

#if DEBUG || ADHOC
    private let clientIdStaging = "394cfec867102a92a17b2acd40234fcd4f692119392a8c29296f70873ff60f4a"
#endif

private var clientId: String {
    #if RELEASE
        return clientIdPro
    #else
        if ApiPath.isPro {
            return clientIdPro
        } else {
            return clientIdStaging
        }
    #endif
}

extension ApiManager {
    class func request(method: HTTPMethod,
                       urlString: String,
                       parameters: [String: Any]? = nil,
                       headers: [String: String]? = nil,
                       completion: Completion?) -> Request? {
        guard !RSError.isNetworkError else {
            completion?(.failure( RSError.Network))
            return nil
        }

        logger.debug("\n url -> \(urlString)")
        logger.debug("\n headers -> \(headers)")
        logger.debug("\n parameters -> \(parameters)\n")

        var encoding: ParameterEncoding = JSONEncoding.default
        if method != .post {
            encoding = URLEncoding.default
        }
        var _headers = api.defaultHTTPHeaders
        _headers.updateValues(headers)

        let request = Alamofire.request(urlString, method: method, parameters: parameters, encoding: encoding, headers: _headers)
        _ = request.validate().responseJSON(completion: { (response) in
            // pre process here

            completion?(response.result)
        })
        return request
    }
}
