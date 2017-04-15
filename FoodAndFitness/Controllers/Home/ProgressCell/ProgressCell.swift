//
//  ProgressCell.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/6/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

final class ProgressCell: BaseTableViewCell {
    @IBOutlet fileprivate(set) weak var progressView: CircleProgressView!
    
    func setup(_ value: CGFloat, duration: CFTimeInterval) {
        progressView.setValue(value, duration: duration)
    }
}
