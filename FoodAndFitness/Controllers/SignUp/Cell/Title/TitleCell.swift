//
//  TitleCell.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/5/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

final class TitleCell: BaseTableViewCell {
    @IBOutlet fileprivate(set) weak var titleLabel: UILabel!

    struct Data {
        var title: String
    }

    var data: Data? {
        didSet {
            guard let data = data else { return }
            titleLabel.text = data.title
        }
    }
}
