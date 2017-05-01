//
//  AnalysisViewController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/23/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftDate
import SwiftUtils

final class AnalysisViewController: RootSideMenuViewController {
    @IBOutlet fileprivate(set) weak var tableView: TableView!
    var viewModel: AnalysisViewModel = AnalysisViewModel()

    enum Rows: Int {
        case barChart
        case nutrition
        case fitness

        static var count: Int {
            return self.fitness.rawValue + 1
        }

        var heightForRow: CGFloat {
            switch self {
            case .barChart:
                return 400
            case .nutrition:
                return 115
            case .fitness:
                return 100
            }
        }
    }

    override func setupUI() {
        super.setupUI()
        configureTableView()
    }

    private func configureTableView() {
        tableView.register(AnalysisNutritionCell.self)
        tableView.register(AnalysisFitnessCell.self)
        tableView.register(ChartViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

// MARK: - UITableViewDataSource
extension AnalysisViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rows = Rows(rawValue: indexPath.row) else { fatalError(Strings.Errors.enumError) }
        switch rows {
        case .barChart:
            let cell = tableView.dequeue(ChartViewCell.self)
            cell.data = viewModel.dataForChartView()
            return cell
        case .nutrition:
            let cell = tableView.dequeue(AnalysisNutritionCell.self)
            cell.data = viewModel.dataForNutritionCell()
            return cell
        case .fitness:
            let cell = tableView.dequeue(AnalysisFitnessCell.self)
            cell.data = viewModel.dataForFitnessCell()
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension AnalysisViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let rows = Rows(rawValue: indexPath.row) else { fatalError(Strings.Errors.enumError) }
        return rows.heightForRow
    }
}
