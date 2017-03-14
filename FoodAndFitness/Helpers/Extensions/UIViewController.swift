//
//  UIViewController.swift
//  RideShare
//
//  Created by Mylo Ho on 3/8/17.
//  Copyright © 2017 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import SwiftUtils

extension UIViewController {
    func presentAlert(title: String, message: String, level: AlertLevel = .normal) {
        let alert = AlertController(title: title, message: message, preferredStyle: .alert)
        alert.level = level
        let okeyAction = UIAlertAction(title: Strings.Okey, style: .default, handler: nil)
        alert.addAction(okeyAction)
        alert.present(from: self, animated: true, completion: nil)
    }
}
