//
//  BaseTableViewCell.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/23/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupData()
        setupUI()
    }

    func setupUI() {}

    func setupData() {
        selectionStyle = .none
    }
}
