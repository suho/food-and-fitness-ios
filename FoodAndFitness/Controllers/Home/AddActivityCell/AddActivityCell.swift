//
//  AddActivityCell.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/15/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

final class AddActivityCell: BaseTableViewCell {
    @IBOutlet fileprivate(set) weak var thumbnailImageView: UIImageView!
    @IBOutlet fileprivate(set) weak var titleLabel: UILabel!
    @IBOutlet fileprivate(set) weak var detailLabel: UILabel!
    @IBOutlet fileprivate(set) weak var addImageView: UIImageView!

    struct Data {
        var thumbnail: UIImage
        var title: String
        var recommend: String?
        var addImage: UIImage?
    }

    var data: Data? {
        didSet {
            guard let data = data else { return }
            thumbnailImageView.image = data.thumbnail
            titleLabel.text = data.title
            detailLabel.text = data.recommend
            addImageView.image = data.addImage
        }
    }
}
