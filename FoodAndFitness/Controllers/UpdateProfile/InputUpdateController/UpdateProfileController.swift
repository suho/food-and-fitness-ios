//
//  UpdateProfileController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 5/8/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

class UpdateProfileController: BaseViewController {
    @IBOutlet fileprivate(set) weak var titleLabel: UILabel!
    @IBOutlet fileprivate(set) weak var textField: UITextField!
    @IBOutlet fileprivate(set) weak var unitLabel: UILabel!

    var viewModel: UpdateProfileViewModel!

    override func setupUI() {
        super.setupUI()
        configureNavigationBar()
        configLabel()
        configTextField()
    }

    private func configureNavigationBar() {
        title = viewModel.row.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Strings.done, style: .done, target: self, action: #selector(update))
    }

    private func configLabel() {
        titleLabel.text = viewModel.row.title
        unitLabel.text = viewModel.row.unit
    }

    private func configTextField() {
        textField.delegate = self
        textField.becomeFirstResponder()
    }

    @objc fileprivate func update() {
        viewModel.value = textField.string
        HUD.show()
        viewModel.update { [weak self](result) in
            HUD.dismiss()
            guard let this = self else { return }
            switch result {
            case .success(_):
                this.navigationController?.popViewController(animated: true)
            case .failure(let error):
                error.show()
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension UpdateProfileController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = Strings.empty
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        guard let number = Int(text + string) else { return false }
        if number > InputCell.maxValue, string != Strings.empty {
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
