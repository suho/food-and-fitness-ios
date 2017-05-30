//
//  TrackingDetailViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 5/29/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import CoreLocation

class TrackingDetailViewModel {

    let params: TrackingParams

    init(params: TrackingParams) {
        self.params = params
    }

    func save(completion: @escaping Completion) {
        if User.me == nil {
            let error = NSError(message: Strings.Errors.tokenError)
            completion(.failure(error))
        } else {
            TrackingServices.save(params: params, completion: completion)
        }
    }

    func data() -> TrackingDetailController.Data {
        let active = Strings.active + ": " + params.active
        let duration = Strings.duration + ": \(params.duration)"
        let distance = Strings.distance + ": \(params.distance)"
        return TrackingDetailController.Data(active: active, duration: duration, distance: distance)
    }

    func coordinatesForMap() -> [CLLocationCoordinate2D] {
        var result: [CLLocationCoordinate2D] = []
        for location in params.locations {
            let clLocation = location.toCLLocation
            result.append(clLocation.coordinate)
        }
        return result
    }
}
