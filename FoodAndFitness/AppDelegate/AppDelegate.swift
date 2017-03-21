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
        let homeController = HomeViewController()
        let navi = UINavigationController(rootViewController: homeController)
        let sideMenuController = SideMenuController()
        sideMenuController.rootViewController = navi
        sideMenuController.setup(.slideAbove)
        if let window = window {
            window.rootViewController = sideMenuController
            window.backgroundColor = .white
            window.makeKeyAndVisible()
        }
        return true
    }
}
