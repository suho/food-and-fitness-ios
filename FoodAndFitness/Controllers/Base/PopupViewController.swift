//
//  PopupViewController.swift
//  RideShare
//
//  Created by DaoNV on 2/15/17.
//  Copyright © 2017 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

class PopupViewController: BaseViewController {

    override func setup() {
        super.setup()
        providesPresentationContextTransitionStyle = true
        definesPresentationContext = true
        modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    }
}
