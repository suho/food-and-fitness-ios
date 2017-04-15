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

    override var isNavigationBarHidden: Bool {
        return false
    }

    override func setupUI() {
        super.setupUI()
        title = Strings.addNutrition
    }

    private func configureSearchBar() {
        searchBar.delegate = self
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UISearchBarDelegate
extension AddNutritionViewController: UISearchBarDelegate {}

// MARK: - UITableViewDataSource
extension AddNutritionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension AddNutritionViewController: UITableViewDelegate {}
