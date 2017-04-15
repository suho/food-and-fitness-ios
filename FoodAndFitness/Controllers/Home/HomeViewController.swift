//
//  HomeViewController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 2/15/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftUtils

final class HomeViewController: RootSideMenuViewController {
    @IBOutlet fileprivate(set) weak var tableView: UITableView!

    enum Sections: Int {
        case progress
        case meals

        static var count: Int {
            return self.meals.hashValue + 1
        }

        var numberOfRows: Int {
            switch self {
            case .progress:
                return 1
            case .meals:
                return 5
            }
        }

        var heightForRows: CGFloat {
            switch self {
            case .progress:
                return 200
            default:
                return 100
            }
        }
    }

    enum AddActivity: Int {
        case breakfast
        case lunch
        case dinner
        case exercise
        case tracking
//        case water
    }

    // MARK: - Cycle Life
    override func setupUI() {
        super.setupUI()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func configureTableView() {
        tableView.register(ProgressCell.self)
        tableView.register(AddActivityCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let nutritionSection = Sections(rawValue: section) else { fatalError(Strings.Errors.enumError) }
        return nutritionSection.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let nutritionSection = Sections(rawValue: indexPath.section) else { fatalError(Strings.Errors.enumError) }
        switch nutritionSection {
        case .progress:
            let cell = tableView.dequeue(ProgressCell.self)
            cell.setup(45, duration: 2)
            return cell
        case .meals:
            guard let activity = AddActivity(rawValue: indexPath.row) else { fatalError(Strings.Errors.enumError) }
            _ = activity
            let cell = tableView.dequeue(AddActivityCell.self)
            return cell
        }
    }
}
// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let nutritionSection = Sections(rawValue: indexPath.section) else { fatalError(Strings.Errors.enumError) }
        return nutritionSection.heightForRows
    }
}
