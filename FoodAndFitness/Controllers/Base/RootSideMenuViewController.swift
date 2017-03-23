//
//  RootSideMenuViewController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/23/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

class RootSideMenuViewController: BaseViewController {

    var sideMenuViewController: SideMenuController {
        guard let sideMenuController = AppDelegate.shared.window?.rootViewController as? SideMenuController else {
            fatalError("Miss SideMenu")
        }
        return sideMenuController
    }

    override func setupUI() {
        super.setupUI()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu"), style: .plain, target: self, action: #selector(showLeftView(sender:)))
    }

    func showLeftView(sender: Any?) {
        sideMenuViewController.showLeftView(animated: true, completionHandler: nil)
    }
}
