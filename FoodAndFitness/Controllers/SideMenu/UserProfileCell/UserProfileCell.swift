//
//  UserProfileCell.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/23/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SDWebImage

protocol UserProfileCellDelegate: NSObjectProtocol {
    func cell(_ cell: UserProfileCell, needsPerformAction action: UserProfileCell.Action)
}

final class UserProfileCell: BaseTableViewCell {
    @IBOutlet fileprivate weak var avatarImageView: UIImageView!
    @IBOutlet fileprivate weak var userNameLabel: UILabel!
    @IBOutlet fileprivate weak var bmiLabel: UILabel!
    
    weak var delegate: UserProfileCellDelegate?

    enum Action {
        case settings
    }

    struct Data {
        var avatarUrl: String?
        var userName: String
        var bmi: String
    }

    var data: Data? {
        didSet {
            guard let data = data else { return }
            if let url = data.avatarUrl {
                avatarImageView.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "avatar_default"))
            } else {
                avatarImageView.image = #imageLiteral(resourceName: "avatar_default")
            }
            userNameLabel.text = data.userName
            bmiLabel.text = data.bmi
        }
    }
    
    @IBAction func settings(_ sender: Any) {
        delegate?.cell(self, needsPerformAction: .settings)
    }
}
