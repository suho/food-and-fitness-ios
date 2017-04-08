//
//  AppDelegate.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/14/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import XCGLogger
import SVProgressHUD
import IQKeyboardManagerSwift

typealias ProgressHUD = SVProgressHUD
let logger = XCGLogger.default

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
        setup()
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            api.session.loadToken()
            if api.session.isAuthenticated {
                gotoHome()
            } else {
                gotoLogin()
            }
            window.backgroundColor = .white
            window.makeKeyAndVisible()
        }
        return true
    }

    func gotoHome() {
        let homeController = UINavigationController(rootViewController: HomeViewController())
        let sideMenuController = SideMenuController()
        sideMenuController.rootViewController = homeController
        sideMenuController.setup(.slideBelow)
        window?.rootViewController = sideMenuController
    }

    func gotoLogin() {
        let signInNaviController = UINavigationController(rootViewController: SignInController())
        window?.rootViewController = signInNaviController
    }

    private func setup() {
        configureLogger()
        configureIQKeyboard()
    }

    private func configureIQKeyboard() {
        IQKeyboardManager.sharedManager().enable = true
    }

    private func configureLogger() {
        logger.setup(level: .verbose,
                     showLogIdentifier: false,
                     showFunctionName: false,
                     showThreadName: false,
                     showLevel: true,
                     showFileNames: false,
                     showLineNumbers: false,
                     showDate: false,
                     writeToFile: nil,
                     fileLevel: nil)
    }
}
