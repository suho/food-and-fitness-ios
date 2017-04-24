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
    var viewModel: UserExercisesDetailViewModel!

    enum Sections: Int {
        case userExercises
        case information
        case suggestion

        static var count: Int {
            return self.suggestion.hashValue + 1
        }

        var title: String {
            switch self {
            case .userExercises:
                return Strings.empty
            case .information:
                return Strings.informationExercise
            case .suggestion:
                return Strings.suggestionExercise
            }
        }

        var heightForHeader: CGFloat {
            switch self {
            case .userExercises:
                return 160
            default:
                return 70
            }
        }
    }

    enum InformationRows: Int {
        case calories
        case duration

        static var count: Int {
            return self.duration.rawValue + 1
        }

        var title: String {
            switch self {
            case .calories:
                return Strings.calories
            case .duration:
                return Strings.duration
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
extension UserExercisesDetailController: UserExercisesDetailViewModelDelegate {
    func viewModel(_ viewModel: UserExercisesDetailViewModel, needsPerformAction action: UserExercisesDetailViewModel.Action) {
        switch action {
        case .userExercisesChanged:
            tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension UserExercisesDetailController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = Sections(rawValue: section) else {
            fatalError(Strings.Errors.enumError)
        }
        switch sections {
        case .userExercises:
            return viewModel.userExercises.count + 1
        case .information:
            return InformationRows.count
        case .suggestion:
            return viewModel.suggestExercises.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sections = Sections(rawValue: indexPath.section) else {
            fatalError(Strings.Errors.enumError)
        }
        switch sections {
        case .userExercises:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeue(AddUserFoodCell.self)
                cell.data = viewModel.dataForAddButton()
                cell.delegate = self
                return cell
            default:
                let cell = tableView.dequeue(UserFoodCell.self)
                cell.accessoryType = .none
                cell.data = viewModel.dataForUserExercise(at: indexPath.row - 1)
                return cell
            }
        case .information:
            guard let rows = InformationRows(rawValue: indexPath.row) else {
                fatalError(Strings.Errors.enumError)
            }
            let cell = tableView.dequeue(InfomationNutritionCell.self)
            cell.data = viewModel.dataForInformationExercise(at: rows)
            return cell
        case .suggestion:
            let cell = tableView.dequeue(UserFoodCell.self)
            cell.accessoryType = .disclosureIndicator
            cell.data = viewModel.dataForSuggestExercise(at: indexPath.row)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension UserExercisesDetailController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sections = Sections(rawValue: indexPath.section) else {
            fatalError(Strings.Errors.enumError)
        }
        switch sections {
        case .userExercises: break
        case .information: break
        case .suggestion:
            let exercises = viewModel.suggestExercises
            guard indexPath.row >= 0, indexPath.row < exercises.count else { break }
            let exerciseDetailController = ExerciseDetailController()
            exerciseDetailController.viewModel = ExerciseDetailViewModel(exercise: exercises[indexPath.row], activity: viewModel.activity)
            navigationController?.pushViewController(exerciseDetailController, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let sections = Sections(rawValue: indexPath.section) else {
            fatalError(Strings.Errors.enumError)
        }
        switch sections {
        case .userExercises:
            return true
        case .information, .suggestion:
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
        if sections == .userExercises && indexPath.row == 0 { return 60 }
        return 50
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let sections = Sections(rawValue: section) else {
            fatalError(Strings.Errors.enumError)
        }
        if sections == .userExercises && viewModel.userExercises.isEmpty {
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
        case .userExercises:
            let headerView: MealHeaderView = MealHeaderView.loadNib()
            headerView.data = viewModel.dataForHeaderView()
            return headerView
        default:
            let headerView: TitleCell = TitleCell.loadNib()
            headerView.data = TitleCell.Data(title: sections.title)
            return headerView.contentView
        }
    }
}

// MARK: - AddUserFoodCellDelegate
extension UserExercisesDetailController: AddUserFoodCellDelegate {
    func cell(_ cell: AddUserFoodCell, needsPerformAction action: AddUserFoodCell.Action) {
        switch action {
        case .add:
            let addActivityController = AddActivityController()
            addActivityController.viewModel = AddActivityViewModel(activity: viewModel.activity)
            navigationController?.pushViewController(addActivityController, animated: true)
        }
    }
}
