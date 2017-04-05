//
//  UserProfileCell.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/23/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

protocol UserProfileCellDelegate: NSObjectProtocol {
    func cell(_ cell: UserProfileCell, needsPerformAction action: UserProfileCell.Action)
}

final class UserProfileCell: BaseTableViewCell {
    weak var delegate: UserProfileCellDelegate?

    enum Action {
        case settings
    }
    
    @IBAction func settings(_ sender: Any) {
        delegate?.cell(self, needsPerformAction: .settings)
    }
}
