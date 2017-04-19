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
import RealmS
import RealmSwift

typealias HUD = SVProgressHUD
let logger = XCGLogger.default
let prefs = UserDefaults.standard

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

        let group = DispatchGroup()
        group.enter()
        downloadDataIfNeeds { 
            group.leave()
        }
        group.notify(queue: .main) { 
            api.session.loadToken()
            if api.session.isAuthenticated {
                self.gotoHome()
            } else {
                self.gotoSignUp()
            }
        }

        if let window = window {
            window.rootViewController = SplashScreenController()
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

    func gotoSignUp() {
        let chooseGoalsController = UINavigationController(rootViewController: ChooseGoalsController())
        window?.rootViewController = chooseGoalsController
    }

    func gotoLogin() {
        let signInNaviController = UINavigationController(rootViewController: SignInController())
        window?.rootViewController = signInNaviController
    }

    private func setup() {
        configureLogger()
        configureIQKeyboard()
        configureRealm()
    }

    private func configureIQKeyboard() {
        IQKeyboardManager.sharedManager().enable = true
    }

    private func configureRealm() {
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        Realm.Configuration.defaultConfiguration = config
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

    private func downloadDataIfNeeds(completion: @escaping () -> Void) {
        let timeInterval: Int = Int(Date().timeIntervalSince1970)
        if let timeIntervalUD = prefs.value(forKey: Key.timeInterval) as? Int {
            let secondsOfWeek = 604_800
            if timeInterval - timeIntervalUD > secondsOfWeek {
                prefs.set(timeInterval, forKey: Key.timeInterval)
                getDatabase(completion: completion)
            } else {
                completion()
            }
        } else {
            prefs.set(timeInterval, forKey: Key.timeInterval)
            getDatabase(completion: completion)
        }
    }

    private func getDatabase(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        group.enter()
        ConfigServices.getFoods { (result) in
            if result.isFailure {
                prefs.removeObject(forKey: Key.timeInterval)
                prefs.synchronize()
            }
            group.leave()
        }
        group.enter()
        ConfigServices.getExercises { (result) in
            if result.isFailure {
                prefs.removeObject(forKey: Key.timeInterval)
                prefs.synchronize()
            }
            group.leave()
        }
        group.notify(queue: .global(), execute: completion)
    }
}
