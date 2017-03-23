//
//  AppDelegate.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/14/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftyBeaver
import SVProgressHUD

typealias ProgressHUD = SVProgressHUD
let logger = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    class var shared: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Index Is Invalid")
        }
        return appDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        gotoHome()
        if let window = window {
            window.backgroundColor = .white
            window.makeKeyAndVisible()
        }
        return true
    }

    func gotoHome() {
        let nutritionController = UINavigationController(rootViewController: NutritionViewController())
        let sideMenuController = SideMenuController()
        sideMenuController.rootViewController = nutritionController
        sideMenuController.setup(.slideAbove)
        window?.rootViewController = sideMenuController
    }
}
