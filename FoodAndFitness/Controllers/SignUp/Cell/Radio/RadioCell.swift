//
//  RadioCell.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/5/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

protocol RadioCellDelegate: NSObjectProtocol {
    func cell(_ cell: RadioCell, didSelectGender gender: Gender)
}

final class RadioCell: BaseTableViewCell {
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var maleButton: UIButton!
    @IBOutlet fileprivate weak var femaleButton: UIButton!
    weak var delegate: RadioCellDelegate?

    enum Action {
        case male
        case female
    }

    struct Data {
        var title: String
    }

    var data: Data? {
        didSet {
            guard let data = data else { return }
            titleLabel.text = data.title
        }
    }

    private func changeButtonStatus() {
        maleButton.isSelected = !maleButton.isSelected
        femaleButton.isSelected = !femaleButton.isSelected
    }

    @IBAction fileprivate func maleClicked(_ sender: Any) {
        delegate?.cell(self, didSelectGender: .male)
        if maleButton.isSelected { return }
        changeButtonStatus()
    }

    @IBAction fileprivate func femaleClicked(_ sender: Any) {
        delegate?.cell(self, didSelectGender: .female)
        if femaleButton.isSelected { return }
        changeButtonStatus()
    }
}
