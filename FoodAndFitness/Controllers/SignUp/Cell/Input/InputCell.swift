//
//  InputCell.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/5/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftDate

protocol InputCellDelegate: NSObjectProtocol {
    func cell(_ cell: InputCell, withInputString string: String)
}

final class InputCell: BaseTableViewCell {
    @IBOutlet fileprivate(set) weak var titleLabel: UILabel!
    @IBOutlet fileprivate(set) weak var textField: UITextField!
    weak var delegate: InputCellDelegate?
    static let maxValue: Int = 250

    struct Data {
        var title: String
        var placeHolder: String
        var detailText: String?
    }

    var cellType: SignUpController.SignUpRow = .fullName {
        didSet {
            switch cellType {
            case .password, .confirmPassword:
                textField.isSecureTextEntry = true
            case .birthday:
                let picker = datePicker()
                textField.inputView = picker
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
            textField.text = data.detailText
        }
    }

    override func setupUI() {
        super.setupUI()
        textField.delegate = self
    }

    private func datePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.setDate(Date(timeIntervalSince1970: 0), animated: true)
        datePicker.minimumDate = Date(timeIntervalSince1970: 0)
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        return datePicker
    }

    @objc fileprivate func datePickerChanged(_ sender: Any) {
        guard let picker = textField.inputView as? UIDatePicker else { return }
        let date = DateInRegion(absoluteDate: picker.date).toString(format: .date)
        textField.text = date
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
        switch cellType {
        case .height, .weight:
            guard let text = textField.text else { return true }
            guard let number = Int(text + string) else { return false }
            if number > InputCell.maxValue, string != Strings.empty {
                return false
            }
        default:
            break
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch cellType {
        case .height, .weight:
            guard let text = textField.text else {
                textField.text = "0"
                return
            }
            if text.characters.isEmpty {
                textField.text = "0"
            }
        default:
            break
        }
        if let string = textField.text {
            delegate?.cell(self, withInputString: string)
        }
    }
}
