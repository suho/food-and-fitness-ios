//
//  AvatarProfileCell.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 5/6/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

class AvatarProfileCell: BaseTableViewCell {
    @IBOutlet fileprivate(set) weak var nameLabel: UILabel!
    @IBOutlet fileprivate(set) weak var bmiLabel: UILabel!
    @IBOutlet fileprivate(set) weak var avatarImageView: UIImageView!

    struct Data {
        var name: String
        var bmi: String
        var avatarUrl: String?
    }

    var data: Data? {
        didSet {
            guard let data = data else { return }
            nameLabel.text = data.name
            bmiLabel.text = data.bmi
            avatarImageView.set(path: data.avatarUrl)
        }
    }
}
