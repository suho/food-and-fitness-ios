//
//  NextButtonCell.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/6/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

protocol NextButtonCellDelegate: NSObjectProtocol {
    func cell(_ cell: NextButtonCell, needsPerformAction action: NextButtonCell.Action)
}

final class NextButtonCell: BaseTableViewCell {

    weak var delegate: NextButtonCellDelegate?

    enum Action {
        case signUp
    }

    @IBAction fileprivate func signUp(_ sender: Any) {
        delegate?.cell(self, needsPerformAction: .signUp)
    }
}
