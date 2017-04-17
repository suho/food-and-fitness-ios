//
//  LeftSideViewController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/21/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftUtils

protocol LeftSideViewControllerDelegate: NSObjectProtocol {
    func viewController(_ viewController: LeftSideViewController, needsPerformAction action: LeftSideViewController.SideMenu)
}

final class LeftSideViewController: UITableViewController {

    enum SideMenu: Int {
        case profile
        case home
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
            case .home:
                return Strings.nutritionAndFitness
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
                return 190
            default:
                return 50
            }
        }

        var deselectedImage: UIImage {
            switch self {
            case .profile:
                fatalError("Don't Need Image")
            case .home:
                return #imageLiteral(resourceName: "ic_home")
            case .history:
                return #imageLiteral(resourceName: "ic_history")
            case .analysis:
                return #imageLiteral(resourceName: "ic_analysis")
            case .information:
                return #imageLiteral(resourceName: "ic_info")
            }
        }
    }

    weak var delegate: LeftSideViewControllerDelegate?
    var viewModel: LeftSideViewModel = LeftSideViewModel()
    
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
            fatalError(Strings.Errors.enumError)
        }
        switch sideMenu {
        case .profile:
            let cell = tableView.dequeue(UserProfileCell.self)
            cell.data = viewModel.dataForUserProfile()
            cell.delegate = self
            return cell
        default:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = sideMenu.title
            cell.imageView?.image = sideMenu.deselectedImage
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension LeftSideViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sideMenu = SideMenu(rawValue: indexPath.row) else {
            fatalError(Strings.Errors.enumError)
        }
        return sideMenu.heightForRow
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sideMenu = SideMenu(rawValue: indexPath.row) else {
            fatalError(Strings.Errors.enumError)
        }
        if sideMenu == .profile { return }
        delegate?.viewController(self, needsPerformAction: sideMenu)
    }
}

// MARK: - UserProfileCellDelegate
extension LeftSideViewController: UserProfileCellDelegate {
    func cell(_ cell: UserProfileCell, needsPerformAction action: UserProfileCell.Action) {
        switch action {
        case .settings:
            delegate?.viewController(self, needsPerformAction: .profile)
        }
    }
}
