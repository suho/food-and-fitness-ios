//
//  SaveUserFoodCell.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/23/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

protocol SaveUserFoodCellDelegate: class {
    func cell(_ cell: SaveUserFoodCell, needsPerformAction action: SaveUserFoodCell.Action)
}

final class SaveUserFoodCell: BaseTableViewCell {

    @IBOutlet fileprivate(set) weak var textField: UITextField!
    @IBOutlet fileprivate(set) weak var label: UILabel!
    weak var delegate: SaveUserFoodCellDelegate?
    var viewModel: SaveUserFoodCellViewModel!
    static let maxValue = 5000

    enum Action {
        case save(Int)
    }

    struct Data {
        var `default`: String
        var calories: String
    }

    var data: Data? {
        didSet {
            guard let data = data else { return }
            textField.text = data.default
            label.text = data.calories
        }
    }

    override func setupUI() {
        super.setupUI()
        textField.delegate = self
    }

    fileprivate func updateCalories(withWeight weight: Int) {
        label.text = viewModel.calories(withWeight: weight)
    }

    @IBAction func save(_ sender: Any?) {
        guard let weight = Int(textField.string), weight > 0 else {
            let error = NSError(message: Strings.Errors.inputNotValidate)
            error.show()
            return
        }
        delegate?.cell(self, needsPerformAction: .save(weight))
    }
}

// MARK: - UITextFieldDelegate
extension SaveUserFoodCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = Strings.empty
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        guard let number = Int(text + string) else { return false }
        updateCalories(withWeight: number)
        if number > SaveUserFoodCell.maxValue, string != Strings.empty {
            return false
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            textField.text = "0"
            return
        }
        if text.characters.isEmpty {
            textField.text = "0"
        }
    }
}
