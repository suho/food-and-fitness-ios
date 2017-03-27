//
//  Date.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/27/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftDate

extension Date {
    func ffDate(format: FFDateFormat = .date) -> DateInRegion {
        return self.inRegion().ffDate(format: format)
    }
}
