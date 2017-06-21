//
//  LeftSideViewController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 5/19/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftUtils

protocol LeftSideViewControllerDelegate: NSObjectProtocol {
    func viewController(_ viewController: LeftSideViewController, needsPerformAction action: LeftSideViewController.SideMenu)
}

final class LeftSideViewController: BaseViewController {

    @IBOutlet fileprivate(set) weak var tableView: UITableView!
    weak var delegate: LeftSideViewControllerDelegate?
    var viewModel: LeftSideViewModel = LeftSideViewModel()

    enum SideMenu: Int {
        case profile
        case home
        case history
        case analysis
        //        case information

        static var count: Int {
            return self.analysis.hashValue + 1
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
//            case .information:
//                return Strings.information
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
                //            case .information:
                //                return #imageLiteral(resourceName: "ic_info")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNotification()
    }

    private func configureNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(uploadPhoto), name: NotificationName.uploadPhoto.toNotiName, object: nil)
    }

    @objc private func uploadPhoto() {
        tableView.reloadData()
    }

    private func configureTableView() {
        tableView.register(UserProfileCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.contentInset.top = 20
        tableView.separatorInset = .zero
        tableView.isScrollEnabled = tableView.contentSize.height > tableView.bounds.height
    }
}

// MARK: - UITableViewDataSource
extension LeftSideViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SideMenu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.textLabel?.text = sideMenu.title
            cell.imageView?.image = sideMenu.deselectedImage.withRenderingMode(.alwaysTemplate)
            if sideMenu == viewModel.selectedMenu {
                cell.imageView?.tintColor = Color.green64
                cell.textLabel?.textColor = Color.green64
            } else {
                cell.imageView?.tintColor = .white
                cell.textLabel?.textColor = .white
            }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension LeftSideViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sideMenu = SideMenu(rawValue: indexPath.row) else {
            fatalError(Strings.Errors.enumError)
        }
        return sideMenu.heightForRow
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sideMenu = SideMenu(rawValue: indexPath.row) else {
            fatalError(Strings.Errors.enumError)
        }
        if sideMenu == .profile { return }
        viewModel.selectedMenu = sideMenu
        tableView.reloadData()
        delegate?.viewController(self, needsPerformAction: sideMenu)
    }
}

// MARK: - UserProfileCellDelegate
extension LeftSideViewController: UserProfileCellDelegate {
    func cell(_ cell: UserProfileCell, needsPerformAction action: UserProfileCell.Action) {
        switch action {
        case .settings:
            viewModel.selectedMenu = .profile
            tableView.reloadData()
            delegate?.viewController(self, needsPerformAction: .profile)
        }
    }
}
