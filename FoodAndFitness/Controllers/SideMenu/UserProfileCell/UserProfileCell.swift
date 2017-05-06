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
    @IBOutlet fileprivate(set) weak var avatarImageView: UIImageView!
    @IBOutlet fileprivate(set) weak var userNameLabel: UILabel!
    @IBOutlet fileprivate(set) weak var bmiLabel: UILabel!
    
    weak var delegate: UserProfileCellDelegate?

    enum Action {
        case settings
    }

    struct Data {
        var avatarUrl: String?
        var userName: String
        var bmi: String
        var status: String
    }

    var data: Data? {
        didSet {
            guard let data = data else { return }
            avatarImageView.set(path: data.avatarUrl)
            userNameLabel.text = data.userName
            bmiLabel.attributedText = attributeText(bmi: data.bmi, status: data.status)
        }
    }

    private func attributeText(bmi: String, status: String) -> NSMutableAttributedString {
        let mutableAttributed: NSMutableAttributedString!
        let bmiAttributed = NSAttributedString(string: bmi, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)])
        mutableAttributed = NSMutableAttributedString(attributedString: bmiAttributed)

        let breakLine = NSAttributedString(string: "\n")
        mutableAttributed.append(breakLine)

        let statusAttributed = NSAttributedString(string: status, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)])
        mutableAttributed.append(statusAttributed)
        return mutableAttributed
    }
    
    @IBAction func settings(_ sender: Any) {
        delegate?.cell(self, needsPerformAction: .settings)
    }
}
