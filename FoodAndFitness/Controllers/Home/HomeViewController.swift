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
        // WARN: - ForTest
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu"), style: .plain, target: self, action: #selector(showLeftView(sender:)))
    }
}
