//
//  ChooseUpdateViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 5/24/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

class ChooseUpdateViewModel {
    enum DataType {
        case goal
        case active

        var title: String {
            switch self {
            case .goal:
                return Strings.goal
            case .active:
                return Strings.active
            }
        }
    }

    var dataType: DataType
    var value: Int = 0

    init(dataType: DataType) {
        self.dataType = dataType
        if let user = User.me, let active = user.active, let goal = user.goal {
            switch dataType {
            case .active:
                value = active.id
            case .goal:
                value = goal.id
            }
        }
    }

    func update(completion: @escaping Completion) {
        var params: UpdateParams!
        switch dataType {
        case .goal:
            params = UpdateParams(goalId: value)
        case .active:
            params = UpdateParams(activeId: value)
        }
        UserServices().update(params: params, completion: completion)
    }

    func getSuggestion(completion: @escaping Completion) {
        guard let me = User.me, let goal = me.goal else {
            completion(.failure(NSError(message: Strings.Errors.tokenError)))
            return
        }
        SuggestionServices.get(goalId: goal.id, completion: completion)
    }
}
