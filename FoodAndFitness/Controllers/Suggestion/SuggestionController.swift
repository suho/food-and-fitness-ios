//
//  SuggestionController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 5/24/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftUtils

final class SuggestionController: BaseViewController {
    @IBOutlet fileprivate weak var tableView: UITableView!

    var viewModel = SuggestionViewModel()

    enum Rows: Int {
        case breakfast
        case lunch
        case dinner
        case exercise

        static var count: Int {
            return self.exercise.rawValue + 1
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
            }
        }

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
            }
        }

        func detail(suggestion: Suggestion) -> String {
            switch self {
            case .breakfast:
                return suggestion.breakfast
            case .lunch:
                return suggestion.lunch
            case .dinner:
                return suggestion.dinner
            case .exercise:
                return suggestion.exercise
            }
        }
    }

    override func setupUI() {
        super.setupUI()
        title = Strings.suggestion
        configTableView()
    }

    private func configTableView() {
        tableView.register(SuggestionCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

// MARK: - UITableViewDataSource
extension SuggestionController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = Rows(rawValue: indexPath.row) else {
            fatalError(Strings.Errors.enumError)
        }
        let cell = tableView.dequeue(SuggestionCell.self)
        cell.data = viewModel.dataForItem(atRow: row)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SuggestionController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
