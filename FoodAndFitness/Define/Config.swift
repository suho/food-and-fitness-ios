//
//  AppConfig.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/7/16.
//  Copyright © 2016 SuHoVan. All rights reserved.
//

import Foundation
import SwiftDate

let kAppVersionKey = "AppVersion"
let kAppBuildKey = "AppBuild"

let kApiPathBaseURLKey = "ApiPathBaseURL"
let kDeviceTokenKey = "DeviceToken"

let kMySetNameNumberKey = "MySetNameNumber"
let kMonthStatesKey = "MonthStates"
let kVideoStandByFlagKey = "stand_by_flag"
let kHighNotificationConfigKey = "hight_notification_config"

let kMaintenanceNotificationName = "MaintenanceNotification"
let kReloadTimelineNotificationName = "ReloadTimelineNotification"
let kReceiveLocalnotificationName = "ReceiveLocalnotification"
let kApplicationDidBecomeActive = "ApplicationDidBecomeActive"
let kRefreshTimelineName = "RefreshTimeline"

// #if (arch(i386) || arch(x86_64)) && os(iOS)

final class App {

    static let name = "カラダかわるNavi"

    // Multi app
    #if RENA
        static let code = "RN"
    #else
        static let code = "TH"
    #endif

    #if RELEASE
        static let GATrackID = "UA-xxxxxxxx-x" // product
    #else
        static let GATrackID = "UA-xxxxxxxx-x" // staging
    #endif

    static let storeLink = "itms-apps://itunes.apple.com/app/idxxxxxxxxx"
    static let storeLinkCaloriMaMa = "itms-apps://itunes.apple.com/app/ixxxxxxxx"
}

let serialQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
}()

let concurQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 6
    return queue
}()
