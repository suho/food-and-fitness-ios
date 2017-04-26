//
//  HistoryViewController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/23/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftUtils

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
    }

    override func setupUI() {
        super.setupUI()
        configureTableView()
    }

    private func configureTableView() {
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
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension HistoryViewController: UITableViewDelegate { }
