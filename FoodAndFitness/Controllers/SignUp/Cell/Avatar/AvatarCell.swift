//
//  AvatarCell.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/5/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

protocol AvatarCellDelegate: NSObjectProtocol {
    func cell(_ cell: AvatarCell, needsPerformAction action: AvatarCell.Action)
}

class AvatarCell: BaseTableViewCell {

    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var avatarImageView: UIImageView!
    weak var delegate: AvatarCellDelegate?

    enum Action {
        case showActionSheet
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

    @IBAction fileprivate func showActionSheet(_ sender: Any) {
        delegate?.cell(self, needsPerformAction: .showActionSheet)
    }
}
