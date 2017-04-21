//
//  UserExercisesDetailController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/18/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftUtils

final class UserExercisesDetailController: BaseViewController {
    @IBOutlet fileprivate(set) weak var tableView: TableView!

    override func setupUI() {
        super.setupUI()
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

// MARK: - UITableViewDataSource
extension UserExercisesDetailController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension UserExercisesDetailController: UITableViewDelegate {}
