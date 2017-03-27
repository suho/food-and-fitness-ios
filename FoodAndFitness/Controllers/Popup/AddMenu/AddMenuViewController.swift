//
//  AddMenuViewController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/26/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

protocol AddMenuViewControllerDelegate: NSObjectProtocol {
    func viewController(_ viewController: AddMenuViewController, needsPerformAction action: AddMenuViewController.Action)
}

class AddMenuViewController: PopupViewController {

    weak var delegate: AddMenuViewControllerDelegate?

    enum Action {
        case addNutrition
        case addFitness
    }

    @IBAction fileprivate func anotherTouch(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction fileprivate func addNutrition(_ sender: Any) {
        dismiss(animated: true) { 
            self.delegate?.viewController(self, needsPerformAction: .addNutrition)
        }
    }

    @IBAction fileprivate func addFitness(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.viewController(self, needsPerformAction: .addFitness)
        }
    }
}
