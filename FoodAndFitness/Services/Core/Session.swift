//
//  Session.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/7/16.
//  Copyright © 2016 SuHoVan. All rights reserved.
//

import Foundation
import SAMKeychain

let kUserIDKey = "UserID"
let kUidKey = "uid"
let kAccessTokenKey = "AccessToken"
let kClientKey = "client"

class Session {

    struct Credential {
        fileprivate(set) var username: String
        fileprivate(set) var password: String

        var isValid: Bool {
            return username.isNotEmpty && password.isNotEmpty
        }
    }

    var credential = Credential(username: "", password: "") {
        didSet {
            saveCredential()
        }
    }

    struct HeaderToken {
        let accessToken: String
        let clientId: String
        let uid: String
    }
    
    var headerToken: HeaderToken? {
        didSet {
            guard let token = headerToken else {
                clearHeaderToken()
                return
            }
            saveHeaderToken(token)
        }
    }

    var userID: Int? = UserDefaults.standard.integer(forKey: kUserIDKey) {
        didSet {
            let userDefaults = UserDefaults.standard
            userDefaults.set(userID, forKey: kUserIDKey)
            userDefaults.synchronize()
        }
    }
    
    var isAuthenticated: Bool {
        return headerToken != nil
    }

    init() { }

    func loadCredential() {
        let host = ApiPath.baseURL.host
        guard let accounts = SAMKeychain.accounts(forService: host)?.last,
            let account = accounts[kSAMKeychainAccountKey] as? String
        else { return }

        guard let password = SAMKeychain.password(forService: host, account: account) else { return }
        credential.username = account
        credential.password = password
    }

    private func saveCredential() {
        guard credential.isValid else { return }
        let host = ApiPath.baseURL.host
        SAMKeychain.setPassword(credential.password, forService: host, account: credential.username)
    }

    private func saveHeaderToken(_ headerToken: HeaderToken) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(headerToken.accessToken, forKey: kAccessTokenKey)
        userDefaults.set(headerToken.uid, forKey: kUidKey)
        userDefaults.set(headerToken.clientId, forKey: kClientKey)
        userDefaults.synchronize()
    }

    func loadAccessToken() {
        let userDefaults = UserDefaults.standard
        
        if let token = userDefaults.string(forKey: kAccessTokenKey), let uid = userDefaults.string(forKey: kUidKey), let client = userDefaults.string(forKey: kClientKey) {
            headerToken = HeaderToken(accessToken: token, clientId: client, uid: uid)
        }
    }

    private func clearHeaderToken() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: kAccessTokenKey)
        userDefaults.removeObject(forKey: kUidKey)
        userDefaults.removeObject(forKey: kClientKey)
        userDefaults.synchronize()
    }

    func clearCredential() {
        credential.username = ""
        credential.password = ""
        let host = ApiPath.baseURL.host
        guard let accounts = SAMKeychain.accounts(forService: host) else { return }
        for account in accounts {
            if let account = account[kSAMKeychainAccountKey] as? String {
                SAMKeychain.deletePassword(forService: host, account: account)
            }
        }
    }

    func reset() {
        headerToken = nil
        clearCredential()
    }
}
