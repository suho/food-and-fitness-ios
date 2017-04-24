//
//  AddUserFoodCell.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/20/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

protocol AddUserFoodCellDelegate: class {
    func cell(_ cell: AddUserFoodCell, needsPerformAction action: AddUserFoodCell.Action)
}

class AddUserFoodCell: BaseTableViewCell {
    @IBOutlet fileprivate(set) weak var button: UIButton!
    weak var delegate: AddUserFoodCellDelegate?

    enum Action {
        case add
    }

    struct Data {
        var buttonTitle: String
    }

    var data: Data? {
        didSet {
            guard let data = data else { return }
            button.setTitle(data.buttonTitle, for: .normal)
        }
    }

    @IBAction func add(_ sender: Any) {
        delegate?.cell(self, needsPerformAction: .add)
    }
}
