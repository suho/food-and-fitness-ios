//
//  LeftSideViewController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/21/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftUtils

class LeftSideViewController: UITableViewController {

    enum SideMenu: Int {
        case profile
        case nutrition
        case fitness
        case history
        case analysis
        case information

        static var count: Int {
            return self.information.hashValue + 1
        }

        var title: String {
            switch self {
            case .profile:
                return Strings.empty
            case .nutrition:
                return Strings.nutrition
            case .fitness:
                return Strings.fitness
            case .history:
                return Strings.history
            case .analysis:
                return Strings.analysis
            case .information:
                return Strings.information
            }
        }

        var heightForRow: CGFloat {
            switch self {
            case .profile:
                return 160
            default:
                return 50
            }
        }

        var deselectedImage: UIImage {
            switch self {
            case .profile:
                fatalError("Don't Need Image")
            case .nutrition:
                return #imageLiteral(resourceName: "ic_nutrition")
            case .fitness:
                return #imageLiteral(resourceName: "ic_fitness")
            case .history:
                return #imageLiteral(resourceName: "ic_history")
            case .analysis:
                return #imageLiteral(resourceName: "ic_analysis")
            case .information:
                return #imageLiteral(resourceName: "ic_info")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    private func configureTableView() {
        tableView.register(UserProfileCell.self)
        tableView.tableFooterView = UIView()
        tableView.contentInset.top = 20
        tableView.separatorInset = .zero
        tableView.isScrollEnabled = tableView.contentSize.height > tableView.bounds.height
    }
}

// MARK: - UITableViewDataSource
extension LeftSideViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SideMenu.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sideMenu = SideMenu(rawValue: indexPath.row) else {
            fatalError("Wrong Index Of Enum")
        }
        switch sideMenu {
        case .profile:
            let cell = tableView.dequeue(UserProfileCell.self)
            return cell
        default:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = sideMenu.title
            cell.imageView?.image = sideMenu.deselectedImage
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension LeftSideViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sideMenu = SideMenu(rawValue: indexPath.row) else {
            fatalError("Wrong Index Of Enum")
        }
        return sideMenu.heightForRow
    }
}
