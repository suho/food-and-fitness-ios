//
//  AddNutritionViewController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/26/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

final class AddNutritionViewController: BaseViewController {

    @IBOutlet fileprivate(set) weak var searchBar: UISearchBar!
    @IBOutlet fileprivate(set) weak var tableView: UITableView!
    var viewModel: AddNutritionViewModel!

    override var isNavigationBarHidden: Bool {
        return false
    }

    override func setupUI() {
        super.setupUI()
        configureNavigationBar()
        configureSearchBar()
        configureTableView()
    }

    private func configureNavigationBar() {
        title = viewModel.title()
    }

    private func configureSearchBar() {
        searchBar.delegate = self
    }

    private func configureTableView() {
        tableView.register(FoodResultCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

// MARK: - UISearchBarDelegate
extension AddNutritionViewController: UISearchBarDelegate {}

// MARK: - UITableViewDataSource
extension AddNutritionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let foods = viewModel.foods else {
            return 0
        }
        return foods.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(FoodResultCell.self)
        cell.data = viewModel.dataForCell(at: indexPath.row)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AddNutritionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
