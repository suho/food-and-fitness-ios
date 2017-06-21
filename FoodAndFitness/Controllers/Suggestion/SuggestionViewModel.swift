//
//  SuggestionViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 5/24/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import RealmSwift
import RealmS
import SwiftDate

final class SuggestionViewModel {

    private var suggestion: Suggestion?

    init() {
        let index = DateInRegion(absoluteDate: Date()).weekday
        let suggestions: [Suggestion] = RealmS().objects(Suggestion.self).filter { (suggestion) -> Bool in
            return SuggestionViewModel.filterByGoal(suggestion: suggestion)
        }
        if index > 0 && index <= suggestions.count {
            suggestion = suggestions[index - 1]
        }
    }

    class func filterByGoal(suggestion: Suggestion) -> Bool {
        if let user = User.me, let userGoal = user.goal, let suggestionGoal = suggestion.goal {
            return userGoal.id == suggestionGoal.id
        } else {
            return false
        }
    }

    func dataForItem(atRow row: SuggestionController.Rows) -> SuggestionCell.Data {
        let image = row.image
        let meal = row.title
        var detail: String?
        if let suggestion = suggestion {
            detail = row.detail(suggestion: suggestion)
        }
        return SuggestionCell.Data(image: image, meal: meal, detail: detail)
    }
}
