//
//  TrackingsDetailViewModel.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/25/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import RealmS
import RealmSwift
import SwiftDate

protocol TrackingsDetailViewModelDelegate: class {
    func viewModel(_ viewModel: TrackingsDetailViewModel, needsPerformAction action: TrackingsDetailViewModel.Action)
}

final class TrackingsDetailViewModel {
    var activity: HomeViewController.AddActivity
    var trackings: [Tracking] {
        return _trackings.filter({ (tracking) -> Bool in
            guard let me = User.me, let user = tracking.user else { return false }
            return tracking.createdAt.isToday && me.id == user.id
        })
    }

    private let _trackings: Results<Tracking>
    private var token: NotificationToken?
    weak var delegate: TrackingsDetailViewModelDelegate?

    enum Action {
        case trackingsChanged
    }

    init(activity: HomeViewController.AddActivity) {
        self.activity = activity
        _trackings = RealmS().objects(Tracking.self)
        token = _trackings.addNotificationBlock({ [weak self](change) in
            guard let this = self else { return }
            switch change {
            case .initial(_): break
            case .error(_): break
            case .update(_, deletions: _, insertions: _, modifications: _):
                this.delegate?.viewModel(this, needsPerformAction: .trackingsChanged)
            }
        })
    }

    func delete(at index: Int, completion: @escaping Completion) {
        guard index >= 0, index < trackings.count else {
            completion(.failure(NSError(message: Strings.Errors.indexNotValidate)))
            return
        }
        let tracking = trackings[index]
        TrackingServices(trackingId: tracking.id).delete(completion: completion)
    }

    func dataForTracking(at index: Int) -> UserFoodCell.Data? {
        guard index >= 0 && index <= trackings.count - 1 else { return nil }
        let tracking = trackings[index]
        let name = tracking.active
        let minutes = tracking.duration.toMinutes
        var timeDetails = ""
        if minutes >= 1 {
            timeDetails = "\(tracking.duration.toMinutes) \(Strings.minute)"
        } else {
            timeDetails = "\(tracking.duration) \(Strings.seconds)"
        }
        let detail = "\(Int(tracking.caloriesBurn)) \(Strings.kilocalories) - \(timeDetails)"
        return UserFoodCell.Data(title: name, detail: detail)
    }

    func dataForHeaderView() -> MealHeaderView.Data? {
        let title = activity.title
        let detail = Date().string(format: FFDateFormat.date.dateFormat, in: Region.GMT())
        return MealHeaderView.Data(title: title, detail: detail, image: activity.image)
    }

    func dataForAddButton() -> AddUserFoodCell.Data? {
        return AddUserFoodCell.Data(buttonTitle: Strings.addMoreTrackings)
    }

    func dataForInformationTrackings(at row: TrackingsDetailController.InformationRows) -> InfomationNutritionCell.Data? {
        let title = row.title
        var detail = ""
        let value = trackings.map({ (tracking) -> Int in
            switch row {
            case .calories:
                return tracking.caloriesBurn
            case .duration:
                return tracking.duration
            case .distance:
                return tracking.distance
            }
        }).reduce(0, { (result, value) -> Int in
            return result + value
        })
        switch row {
        case .calories:
            detail = "\(value) \(Strings.kilocalories)"
        case .duration:
            detail = "\(value) \(Strings.minute)"
        case .distance:
            detail = "\(value) \(Strings.metters)"
        }
        return InfomationNutritionCell.Data(title: title, detail: detail)
    }
}
