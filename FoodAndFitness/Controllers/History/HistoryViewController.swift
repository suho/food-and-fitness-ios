//
//  HistoryViewController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/23/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftUtils
import SwiftDate

final class HistoryViewController: BaseViewController {
    @IBOutlet fileprivate(set) weak var tableView: TableView!
    var viewModel: HistoryViewModel!

    enum Sections: Int {
        case progress
        case breakfast
        case lunch
        case dinner
        case userExercises
        case trackings

        static var count: Int {
            return self.trackings.rawValue + 1
        }

        var title: String {
            switch self {
            case .progress:
                return Strings.empty
            case .breakfast:
                return Strings.breakfast
            case .lunch:
                return Strings.lunch
            case .dinner:
                return Strings.dinner
            case .userExercises:
                return Strings.exercise
            case .trackings:
                return Strings.tracking
            }
        }

        var heightForRow: CGFloat {
            switch self {
            case .progress:
                return 200
            default:
                return 60
            }
        }

        var heightForHeader: CGFloat {
            switch self {
            case .progress:
                return 0
            default:
                return 50
            }
        }
    }

    override func setupUI() {
        super.setupUI()
        title = DateInRegion(absoluteDate: viewModel.date).ffDate().toString(format: .date)
        configureTableView()
    }

    private func configureTableView() {
        tableView.register(ProgressCell.self)
        tableView.register(UserFoodCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

// MARK: - UITableViewDataSource
extension HistoryViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = Sections(rawValue: section) else {
            fatalError(Strings.Errors.enumError)
        }
        switch sections {
        case .progress:
            return 1
        case .breakfast:
            return viewModel.breakfastFoods.count
        case .lunch:
            return viewModel.lunchFoods.count
        case .dinner:
            return viewModel.dinnerFoods.count
        case .userExercises:
            return viewModel.userExercises.count
        case .trackings:
            return viewModel.trackings.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sections = Sections(rawValue: indexPath.section) else {
            fatalError(Strings.Errors.enumError)
        }
        switch sections {
        case .progress:
            let cell = tableView.dequeue(ProgressCell.self)
            cell.data = viewModel.dataForProgressCell()
            return cell
        case .breakfast:
            let cell = tableView.dequeue(UserFoodCell.self)
            cell.accessoryType = .none
            let userFood = viewModel.breakfastFoods[indexPath.row]
            if let food = userFood.food {
                cell.data = UserFoodCell.Data(title: food.name, detail: "\(food.calories)", image: #imageLiteral(resourceName: "ic_food"))
            }
            return cell
        case .lunch:
            let cell = tableView.dequeue(UserFoodCell.self)
            cell.accessoryType = .none
            let userFood = viewModel.lunchFoods[indexPath.row]
            if let food = userFood.food {
                cell.data = UserFoodCell.Data(title: food.name, detail: "\(food.calories)", image: #imageLiteral(resourceName: "ic_food"))
            }
            return cell
        case .dinner:
            let cell = tableView.dequeue(UserFoodCell.self)
            cell.accessoryType = .none
            let userFood = viewModel.dinnerFoods[indexPath.row]
            if let food = userFood.food {
                cell.data = UserFoodCell.Data(title: food.name, detail: "\(food.calories)", image: #imageLiteral(resourceName: "ic_food"))
            }
            return cell
        case .userExercises:
            let cell = tableView.dequeue(UserFoodCell.self)
            cell.accessoryType = .none
            let userExercise = viewModel.userExercises[indexPath.row]
            if let exercise = userExercise.exercise {
                cell.data = UserFoodCell.Data(title: exercise.name, detail: "\(exercise.calories)", image: #imageLiteral(resourceName: "ic_trainers"))
            }
            return cell
        case .trackings:
            let cell = tableView.dequeue(UserFoodCell.self)
            cell.accessoryType = .none
            let tracking = viewModel.trackings[indexPath.row]
            cell.data = UserFoodCell.Data(title: tracking.active, detail: "\(tracking.caloriesBurn) - \(tracking.distance) - \(tracking.duration)", image: #imageLiteral(resourceName: "ic_trainers"))
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension HistoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sections = Sections(rawValue: section) else {
            fatalError(Strings.Errors.enumError)
        }
        return sections.heightForHeader
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sections = Sections(rawValue: section) else {
            fatalError(Strings.Errors.enumError)
        }
        switch sections {
        case .progress:
            return nil
        default:
            let headerView: TitleCell = TitleCell.loadNib()
            headerView.data = TitleCell.Data(title: sections.title)
            return headerView.contentView
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sections = Sections(rawValue: indexPath.section) else {
            fatalError(Strings.Errors.enumError)
        }
        return sections.heightForRow
    }
}
