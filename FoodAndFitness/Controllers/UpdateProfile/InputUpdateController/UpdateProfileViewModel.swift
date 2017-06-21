//
//  UpdateProfileViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 5/8/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

struct UpdateParams {
    var weight: String?
    var height: String?
    var goalId: Int?
    var activeId: Int?

    init(weight: String) {
        self.weight = weight
    }

    init(height: String) {
        self.height = height
    }

    init(goalId: Int) {
        self.goalId = goalId
    }

    init(activeId: Int) {
        self.activeId = activeId
    }
}

class UpdateProfileViewModel {

    var row: Row

    enum Row {
        case weight
        case height

        var title: String {
            switch self {
            case .weight:
                return Strings.weight
            case .height:
                return Strings.height
            }
        }

        var unit: String {
            switch self {
            case .weight:
                return Strings.kilogam
            case .height:
                return Strings.centimeter
            }
        }
    }

    var value: String = ""

    init(row: Row) {
        self.row = row
    }

    private func validate() -> Validation {
        guard value.isNotEmpty, (Int(value) != nil) else {
            return .failure(Strings.Errors.inputNotValidate)
        }
        return .success
    }

    func update(completion: @escaping Completion) {
        switch validate() {
        case .success:
            var params: UpdateParams!
            switch row {
            case .weight:
                params = UpdateParams(weight: value)
            case .height:
                params = UpdateParams(height: value)
            }
            UserServices().update(params: params, completion: completion)
        case .failure(let message):
            completion(.failure(NSError(message: message)))
        }
    }
}
