//
//  UserFoodsDetailController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/16/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftUtils

class UserFoodsDetailController: BaseViewController {
    @IBOutlet fileprivate(set) weak var tableView: TableView!
    var viewModel: UserFoodsDetailViewModel!

    enum Sections: Int {
        case userFoods
        case information
        case suggestion

        static var count: Int {
            return self.suggestion.hashValue + 1
        }
    }

    override func setupUI() {
        super.setupUI()
        configureTableView()
    }

    private func configureTableView() {
        tableView.register(AddUserFoodCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

// MARK: - UITableViewDataSource
extension UserFoodsDetailController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = Sections(rawValue: section) else {
            fatalError(Strings.Errors.enumError)
        }
        switch sections {
        case .userFoods:
            return viewModel.userFoods.count + 1
        case .information:
            return 4
        case .suggestion:
            return viewModel.suggestFoods.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sections = Sections(rawValue: indexPath.section) else {
            fatalError(Strings.Errors.enumError)
        }
        switch sections {
        case .userFoods:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeue(AddUserFoodCell.self)
                cell.delegate = self
                return cell
            default: break

            }
        case .information: break

        case .suggestion: break

        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension UserFoodsDetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sections = Sections(rawValue: section) else {
            fatalError(Strings.Errors.enumError)
        }
        switch sections {
        case .userFoods:
            return 140
        default:
            return 70
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sections = Sections(rawValue: section) else {
            fatalError(Strings.Errors.enumError)
        }
        switch sections {
        case .userFoods:
            let headerView: MealHeaderView = MealHeaderView.loadNib()
            return headerView
        default:
            let headerView: TitleCell = TitleCell.loadNib()
            return headerView
        }
    }
}

// MARK: - AddUserFoodCellDelegate
extension UserFoodsDetailController: AddUserFoodCellDelegate {
    func cell(_ cell: AddUserFoodCell, needsPerformAction action: AddUserFoodCell.Action) {
        switch action {
        case .add:
            let addActivityController = AddActivityController()
            addActivityController.viewModel = AddActivityViewModel(activity: viewModel.activity)
            navigationController?.pushViewController(addActivityController, animated: true)

        }
    }
}
