//
//  InputCell.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/5/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftDate

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
            case .birthday:
                textField.text = DateInRegion(timeIntervalSince1970: 0).toString(format: .date)
            case .height:
                textField.keyboardType = .numberPad
                textField.setUnit(text: Strings.centimeter, textColor: Color.blue63)
            case .weight:
                textField.keyboardType = .numberPad
                textField.setUnit(text: Strings.kilogam, textColor: Color.blue63)
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

    override func setupUI() {
        super.setupUI()
        textField.delegate = self
    }
}

// MARK: - UITextFieldDelegate
extension InputCell: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch cellType {
        case .height, .weight:
            textField.text = Strings.empty
        default:
            break
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        guard let number = Int(text) else { return true }
        if number > 250, string != Strings.empty {
            textField.text = String(describing: textField.text?.characters.dropLast())
            return false
        }
        return true
    }
}
