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

class SideMenuController: LGSideMenuController {

    static let shared = SideMenuController()
    private var leftSideViewController = LeftSideViewController()

    override func leftViewWillLayoutSubviews(with size: CGSize) {
        super.leftViewWillLayoutSubviews(with: size)
        leftView?.frame = CGRect(origin: .zero, size: size)
    }

    func setup(_ style: LGSideMenuPresentationStyle) {
        leftViewController = leftSideViewController
        leftViewWidth = kScreenSize.width * (3 / 4)
        leftViewPresentationStyle = style
    }
}
