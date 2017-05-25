//
//  SuggestionCell.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 5/24/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

final class SuggestionCell: BaseTableViewCell {
    @IBOutlet fileprivate weak var thumbnailImageView: UIImageView!
    @IBOutlet fileprivate weak var mealLabel: UILabel!
    @IBOutlet fileprivate weak var detailLabel: UILabel!

    struct Data {
        var image: UIImage
        var meal: String
        var detail: String?
    }

    var data: Data? {
        didSet {
            guard let data = data else { return }
            thumbnailImageView.image = data.image
            mealLabel.text = data.meal
            detailLabel.text = data.detail ?? "abc"
        }
    }
}
