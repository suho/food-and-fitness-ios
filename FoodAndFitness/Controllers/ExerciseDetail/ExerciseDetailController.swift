//
//  ExerciseDetailController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/24/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftUtils

class ExerciseDetailController: BaseViewController {
    @IBOutlet fileprivate(set) weak var tableView: TableView!

    var viewModel: ExerciseDetailViewModel!

    override var isNavigationBarHidden: Bool {
        return true
    }

    enum Rows: Int {
        case addUserExercise

        static var count: Int {
            return self.addUserExercise.rawValue + 1
        }

        var height: CGFloat {
            switch self {
            case .addUserExercise:
                return 155
            }
        }
    }

    override func setupUI() {
        super.setupUI()
        configureTableView()
        configureNavigationBar()
    }

    private func configureNavigationBar() {
        title = viewModel.exercise.name
    }

    private func configureTableView() {
        tableView.register(AddUserExerciseCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

// MARK: - UITableViewDataSource
extension ExerciseDetailController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = Rows(rawValue: indexPath.row) else {
            fatalError(Strings.Errors.enumError)
        }
        switch row {
        case .addUserExercise:
            let cell = tableView.dequeue(AddUserExerciseCell.self)
            cell.viewModel = AddUserExerciseViewModel(exercise: viewModel.exercise)
            cell.data = viewModel.dataForAddUserExercise()
            cell.delegate = self
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension ExerciseDetailController: UITableViewDelegate {
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

// MARK: - 
extension ExerciseDetailController: MealHeaderViewDelegate {
    func view(_ view: MealHeaderView, needsPerformAction action: MealHeaderView.Action) {
        back(view.backButton)
    }
}

// MARK: - AddUserExerciseCellDelegate
extension ExerciseDetailController: AddUserExerciseCellDelegate {
    func cell(_ cell: AddUserExerciseCell, needsPerformAction action: AddUserExerciseCell.Action) {
        switch action {
        case .save(let duration):
            HUD.show()
            viewModel.save(duration: duration, completion: { [weak self](result) in
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
