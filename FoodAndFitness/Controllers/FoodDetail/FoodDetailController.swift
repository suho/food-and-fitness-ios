//
//  FoodDetailController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/15/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftUtils

final class FoodDetailController: BaseViewController {
    @IBOutlet fileprivate(set) weak var tableView: TableView!
    var viewModel: FoodDetailViewModel!

    override var isNavigationBarHidden: Bool {
        return true
    }

    enum Rows: Int {
        case addUserFood
        case informations

        static var count: Int {
            return self.informations.rawValue + 1
        }

        var height: CGFloat {
            switch self {
            case .addUserFood:
                return 155
            case .informations:
                return 145
            }
        }
    }

    override func setupUI() {
        super.setupUI()
        configureTableView()
        configureNavigationBar()
    }

    private func configureNavigationBar() {
        title = viewModel.food.name
    }

    private func configureTableView() {
        tableView.register(SaveUserFoodCell.self)
        tableView.register(InformationFoodCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

// MARK: - UITableViewDataSource
extension FoodDetailController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = Rows(rawValue: indexPath.row) else {
            fatalError(Strings.Errors.enumError)
        }
        switch row {
        case .addUserFood:
            let cell = tableView.dequeue(SaveUserFoodCell.self)
            cell.viewModel = SaveUserFoodCellViewModel(food: viewModel.food)
            cell.data = viewModel.dataForSaveUserFood()
            cell.delegate = self
            return cell
        case .informations:
            let cell = tableView.dequeue(InformationFoodCell.self)
            cell.data = viewModel.dataForInformationFood()
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension FoodDetailController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let row = Rows(rawValue: indexPath.row) else {
            fatalError(Strings.Errors.enumError)
        }
        return row.height
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 234
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: MealHeaderView = MealHeaderView.loadNib()
        headerView.delegate = self
        headerView.data = viewModel.dataForHeaderView()
        return headerView
    }
}

// MARK: - MealHeaderViewDelegate
extension FoodDetailController: MealHeaderViewDelegate {
    func view(_ view: MealHeaderView, needsPerformAction action: MealHeaderView.Action) {
        back(view.backButton)
    }
}

// MARK: - SaveUserFoodCellDelegate
extension FoodDetailController: SaveUserFoodCellDelegate {
    func cell(_ cell: SaveUserFoodCell, needsPerformAction action: SaveUserFoodCell.Action) {
        switch action {
        case .save(let weight):
            HUD.show()
            viewModel.save(weight: weight, completion: { [weak self](result) in
                HUD.dismiss()
                guard let this = self else { return }
                switch result {
                case .success(_):
                    this.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    error.show()
                }
            })
        }
    }
}
