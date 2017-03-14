//
//  AppDelegate.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/14/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeViewController = HomeViewController()
        if let window = window {
            window.rootViewController = homeViewController
            window.backgroundColor = .white
            window.makeKeyAndVisible()
        }
        return true
    }
}

