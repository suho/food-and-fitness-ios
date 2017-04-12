//
//  Optional.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/11/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import Foundation

extension Optional {

    func toOptionalString() -> String? {
        switch self {
        case .some(let value):
            return "\(value)"
        case .none:
            return nil
        }
    }

    func toString() -> String {
        switch self {
        case .some(let value):
            return "\(value)"
        case .none:
            return ""
        }
    }
}
