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
    var viewModel: HomeViewModel = HomeViewModel()

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

        var title: String {
            switch self {
            case .breakfast:
                return Strings.breakfast
            case .lunch:
                return Strings.lunch
            case .dinner:
                return Strings.dinner
            case .exercise:
                return Strings.exercise
            case .tracking:
                return Strings.tracking
            }
        }

        var image: UIImage {
            switch self {
            case .breakfast:
                return #imageLiteral(resourceName: "img_breakfast")
            case .lunch:
                return #imageLiteral(resourceName: "img_lunch")
            case .dinner:
                return #imageLiteral(resourceName: "img_dinner")
            case .exercise:
                return #imageLiteral(resourceName: "img_exercise")
            case .tracking:
                return #imageLiteral(resourceName: "img_tracking")
            }
        }
    }

    // MARK: - Cycle Life
    override func setupUI() {
        super.setupUI()
        configureNavigationBar()
        configureTableView()
        configureViewModel()
    }

    // MARK: - Private Functions
    private func configureViewModel() {
        viewModel.delegate = self
    }

    private func configureNavigationBar() {
        title = Strings.nutritionAndFitness
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_info"), style: .plain, target: self, action: #selector(showSuggest))
    }

    private func configureTableView() {
        tableView.register(ProgressCell.self)
        tableView.register(AddActivityCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    @objc private func showSuggest() {
        print("Show Suggestion")
    }
}

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func viewModel(_ viewModel: HomeViewModel, needsPerformAction action: HomeViewModel.Action) {
        tableView.reloadData()
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
            cell.data = viewModel.dataForProgressCell()
            cell.progressValue = viewModel.valueForProgressBar()
            return cell
        case .meals:
            guard let activity = AddActivity(rawValue: indexPath.row) else { fatalError(Strings.Errors.enumError) }
            let cell = tableView.dequeue(AddActivityCell.self)
            cell.data = viewModel.dataForAddActivityCell(activity: activity)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nutritionSection = Sections(rawValue: indexPath.section) else { fatalError(Strings.Errors.enumError) }
        switch nutritionSection {
        case .progress: break
        case .meals:
            guard let activity = AddActivity(rawValue: indexPath.row) else { fatalError(Strings.Errors.enumError) }
            switch activity {
            case .breakfast, .lunch, .dinner:
                let userFoodsController = UserFoodsDetailController()
                userFoodsController.viewModel = UserFoodsDetailViewModel(activity: activity)
                navigationController?.pushViewController(userFoodsController, animated: true)
            case .exercise:
                let userExercisesController = UserExercisesDetailController()
                userExercisesController.viewModel = UserExercisesDetailViewModel(activity: activity)
                navigationController?.pushViewController(userExercisesController, animated: true)
            case .tracking:
                let trackingsDetailController = TrackingsDetailController()
                navigationController?.pushViewController(trackingsDetailController, animated: true)
            }
        }
    }
}
