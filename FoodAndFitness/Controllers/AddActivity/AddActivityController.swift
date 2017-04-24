//
//  AddActivityController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/26/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftUtils

final class AddActivityController: BaseViewController {

    @IBOutlet fileprivate(set) weak var searchBar: UISearchBar!
    @IBOutlet fileprivate(set) weak var tableView: UITableView!
    fileprivate var searchTimer: Timer?
    var viewModel: AddActivityViewModel!

    enum Action {
        case didAddActivity
    }

    override var isNavigationBarHidden: Bool {
        return false
    }

    override func setupUI() {
        super.setupUI()
        configureNavigationBar()
        configureSearchBar()
        configureTableView()
    }

    @objc fileprivate func search() {
        guard let keyword = searchBar.text, keyword.trimmed().characters.isNotEmpty else {
            viewModel.keyword = ""
            tableView.reloadData()
            return
        }
        viewModel.keyword = keyword
        tableView.reloadData()
    }

    private func configureNavigationBar() {
        title = viewModel.title()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Strings.update, style: .plain, target: self, action: #selector(updateData))
    }

    @objc private func updateData() {
        HUD.show()
        viewModel.updateData {
            HUD.dismiss()
        }
    }

    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
    }

    private func configureTableView() {
        tableView.register(ResultCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

// MARK: - UISearchBarDelegate
extension AddActivityController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(search), userInfo: nil, repeats: false)
        return true
    }
}

// MARK: - UITableViewDataSource
extension AddActivityController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = viewModel.numberOfRows()
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ResultCell.self)
        cell.data = viewModel.dataForCell(at: indexPath.row)
        if indexPath.row.isEven {
            cell.backgroundColor = .white
        } else {
            cell.backgroundColor = Color.gray245
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AddActivityController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.activity {
        case .breakfast, .lunch, .dinner:
            guard let foods = viewModel.foods else { break }
            guard indexPath.row >= 0, indexPath.row < foods.count else { break }
            let foodDetailController = FoodDetailController()
            foodDetailController.viewModel = FoodDetailViewModel(food: foods[indexPath.row], activity: viewModel.activity)
            navigationController?.pushViewController(foodDetailController, animated: true)
        case .exercise:
            guard let exercises = viewModel.exercises else { return }
            guard indexPath.row >= 0, indexPath.row < exercises.count else { break }
            let exerciseDetailController = ExerciseDetailController()
            exerciseDetailController.viewModel = ExerciseDetailViewModel(exercise: exercises[indexPath.row], activity: viewModel.activity)
            navigationController?.pushViewController(exerciseDetailController, animated: true)
        case .tracking: break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
