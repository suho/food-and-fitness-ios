//
//  UIImageView.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 5/6/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    func set(path: String?, placeHolderImage: UIImage = #imageLiteral(resourceName: "img_avatar_default")) {
        guard let path = path, let url = URL(string: path) else {
            image = placeHolderImage
            return
        }
        sd_setImage(with: url, placeholderImage: placeHolderImage)
    }
}
