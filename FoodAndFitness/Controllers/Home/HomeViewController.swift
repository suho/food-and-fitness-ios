//
//  HomeViewController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 2/15/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    override func setupUI() {
        super.setupUI()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: .plain, target: self, action: #selector(showLeftView(sender:)))
    }

    func showLeftView(sender: Any?) {
        if let sideMenuController = AppDelegate.shared.window?.rootViewController as? SideMenuController {
            sideMenuController.showLeftView(animated: true, completionHandler: nil)
        }
    }
}
