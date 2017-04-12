//
//  SideMenuController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 2/15/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import Foundation
import LGSideMenuController
import SwiftUtils

final class SideMenuController: LGSideMenuController {

    static let shared = SideMenuController()
    private var leftSideViewController = LeftSideViewController()
    fileprivate(set) var currentSideMenu: LeftSideViewController.SideMenu = .home

    override func leftViewWillLayoutSubviews(with size: CGSize) {
        super.leftViewWillLayoutSubviews(with: size)
        leftView?.frame = CGRect(origin: .zero, size: size)
    }

    func setup(_ style: LGSideMenuPresentationStyle) {
        leftSideViewController.delegate = self
        leftViewController = leftSideViewController
        leftViewWidth = kScreenSize.width * (3 / 4)
        leftViewPresentationStyle = style
    }
}

extension SideMenuController: LeftSideViewControllerDelegate {
    func viewController(_ viewController: LeftSideViewController, needsPerformAction action: LeftSideViewController.SideMenu) {
        if currentSideMenu == action {
            self.hideLeftView(animated: true, completionHandler: nil)
            return
        }
        switch action {
        case .profile:
            let profileControler = UINavigationController(rootViewController: ProfileViewController())
            self.rootViewController = profileControler
        case .home:
            let homeController = UINavigationController(rootViewController: HomeViewController())
            self.rootViewController = homeController
        case .history:
            let historyController = UINavigationController(rootViewController: CalendarController())
            self.rootViewController = historyController
        case .analysis:
            let analysisController = UINavigationController(rootViewController: AnalysisViewController())
            self.rootViewController = analysisController
        case .information:
//            let informationController = UINavigationController(rootViewController: InformationViewController())
//            self.rootViewController = informationController
            api.logout()
            AppDelegate.shared.gotoSignUp()
        }
        currentSideMenu = action
        self.hideLeftView(animated: true, completionHandler: nil)
    }
}
