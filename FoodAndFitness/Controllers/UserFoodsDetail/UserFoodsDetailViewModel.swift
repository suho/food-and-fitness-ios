//
//  UserFoodsDetailViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/16/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import RealmS
import RealmSwift

class UserFoodsDetailViewModel {

    var activity: HomeViewController.AddActivity
    let userFoods: [UserFood]
    let suggestFoods: [Food]

    init(activity: HomeViewController.AddActivity) {
        self.activity = activity
        userFoods = RealmS().objects(UserFood.self).filter({ (_) -> Bool in
            return true
        })
        suggestFoods = RealmS().objects(Food.self).filter({ (_) -> Bool in
            return true
        })
    }
}
