//
//  InputCell.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/5/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

class InputCell: BaseTableViewCell {
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var textField: UITextField!

    struct Data {
        var title: String
        var placeHolder: String
    }

    var cellType: SignUpController.SignUpRow = .fullName {
        didSet {
            switch cellType {
            case .password, .confirmPassword:
                textField.isSecureTextEntry = true
            default: break
            }
        }
    }

    var data: Data? {
        didSet {
            guard let data = data else { return }
            titleLabel.text = data.title
            textField.placeholder = data.placeHolder
        }
    }
}
