//
//  TrackingsDetailController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/25/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftUtils

final class TrackingsDetailController: BaseViewController {
    @IBOutlet fileprivate(set) weak var tableView: TableView!

    var viewModel: TrackingsDetailViewModel = TrackingsDetailViewModel(activity: .tracking)

    enum Sections: Int {
        case trackings
        case information

        static var count: Int {
            return self.information.rawValue + 1
        }

        var title: String {
            switch self {
            case .trackings:
                return Strings.empty
            case .information:
                return Strings.informationTracking
            }
        }

        var heightForHeader: CGFloat {
            switch self {
            case .trackings:
                return 160
            default:
                return 70
            }
        }
    }

    enum InformationRows: Int {
        case calories
        case duration
        case distance

        static var count: Int {
            return self.distance.rawValue + 1
        }

        var title: String {
            switch self {
            case .calories:
                return Strings.calories
            case .duration:
                return Strings.duration
            case .distance:
                return Strings.distance
            }
        }
    }

    override func setupUI() {
        super.setupUI()
        configureTableView()
        configureViewModel()
    }

    private func configureTableView() {
        tableView.register(AddUserFoodCell.self)
        tableView.register(UserFoodCell.self)
        tableView.register(InfomationNutritionCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    private func configureViewModel() {
        viewModel.delegate = self
    }
}

// MARK: - UserExercisesDetailViewModelDelegate
extension TrackingsDetailController: TrackingsDetailViewModelDelegate {
    func viewModel(_ viewModel: TrackingsDetailViewModel, needsPerformAction action: TrackingsDetailViewModel.Action) {
        switch action {
        case .trackingsChanged:
            tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension TrackingsDetailController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = Sections(rawValue: section) else {
            fatalError(Strings.Errors.enumError)
        }
        switch sections {
        case .trackings:
            return viewModel.trackings.count + 1
        case .information:
            return InformationRows.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sections = Sections(rawValue: indexPath.section) else {
            fatalError(Strings.Errors.enumError)
        }
        switch sections {
        case .trackings:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeue(AddUserFoodCell.self)
                cell.data = viewModel.dataForAddButton()
                cell.delegate = self
                return cell
            default:
                let cell = tableView.dequeue(UserFoodCell.self)
                cell.accessoryType = .none
                cell.data = viewModel.dataForTracking(at: indexPath.row - 1)
                return cell
            }
        case .information:
            guard let rows = InformationRows(rawValue: indexPath.row) else {
                fatalError(Strings.Errors.enumError)
            }
            let cell = tableView.dequeue(InfomationNutritionCell.self)
            cell.data = viewModel.dataForInformationTrackings(at: rows)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension TrackingsDetailController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sections = Sections(rawValue: indexPath.section) else {
            fatalError(Strings.Errors.enumError)
        }
        switch sections {
        case .trackings: break
        case .information: break
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let sections = Sections(rawValue: indexPath.section) else {
            fatalError(Strings.Errors.enumError)
        }
        switch sections {
        case .trackings:
            return true
        case .information:
            return false
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            viewModel.delete(at: indexPath.row - 1, completion: { (result) in
                switch result {
                case .success(_):
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                case .failure(let error):
                    error.show()
                }
            })
        default: break
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sections = Sections(rawValue: section) else {
            fatalError(Strings.Errors.enumError)
        }
        return sections.heightForHeader
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sections = Sections(rawValue: indexPath.section) else {
            fatalError(Strings.Errors.enumError)
        }
        if sections == .trackings && indexPath.row == 0 { return 60 }
        return 60
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let sections = Sections(rawValue: section) else {
            fatalError(Strings.Errors.enumError)
        }
        if sections == .trackings && viewModel.trackings.isEmpty {
            return .leastNormalMagnitude
        } else {
            return 10
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sections = Sections(rawValue: section) else {
            fatalError(Strings.Errors.enumError)
        }
        switch sections {
        case .trackings:
            let headerView: MealHeaderView = MealHeaderView.loadNib()
            headerView.data = viewModel.dataForHeaderView()
            return headerView
        case .information:
            let headerView: TitleCell = TitleCell.loadNib()
            headerView.data = TitleCell.Data(title: sections.title)
            return headerView.contentView
        }
    }
}

// MARK: - AddUserFoodCellDelegate
extension TrackingsDetailController: AddUserFoodCellDelegate {
    func cell(_ cell: AddUserFoodCell, needsPerformAction action: AddUserFoodCell.Action) {
        switch action {
        case .add:
            let trackingController = TrackingController()
            navigationController?.pushViewController(trackingController, animated: true)
        }
    }
}
