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
            completion?(.failure(FFError.network))
            return nil
        }

        var encoding: ParameterEncoding = URLEncoding.default
        if method == .post {
            encoding = JSONEncoding.default
        }
        
        var _headers = api.defaultHTTPHeaders
        _headers.updateValues(headers)

        let request = Alamofire.request(urlString, method: method, parameters: parameters, encoding: encoding, headers: _headers)
        _ = request.responseJSON(completion: { (response) in
            completion?(response.result)
        })
        return request
    }
}

// MARK: NSMutableData
extension NSMutableData {
    func append(string: String) {
        if let data = string.data(using: .utf8, allowLossyConversion: true) {
            append(data)
        }
    }
}

// MARK: NSMutableURLRequest
extension NSMutableURLRequest {
    func httpBody(key: String, value: Data, boundary: String) {
        let mutableData = NSMutableData()
        mutableData.append(string: "--\(boundary)\r\n")
        mutableData.append(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"user-profile.jpg\"\r\n")
        mutableData.append(string: "Content-Type: image/jpg\r\n\r\n")
        mutableData.append(value)
        mutableData.append(string: "\r\n")
        mutableData.append(string: "--\(boundary)--\r\n")
        httpBody = mutableData as Data
    }

    func addHeaders(boundary: String) {
        guard let token = api.session.token else {
            return
        }
        for key in Session.Token.allKeys {
            if let value = token.values[key] {
                addValue(value, forHTTPHeaderField: key)
            }
        }
        addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    }
}
