//
//  FoodDetailViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/15/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import RealmSwift
import RealmS

final class FoodDetailViewModel {
    var food: Food

    init(food: Food) {
        self.food = food
    }
}
