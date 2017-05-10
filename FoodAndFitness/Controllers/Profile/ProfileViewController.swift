//
//  ProfileViewController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/23/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftUtils

final class ProfileViewController: RootSideMenuViewController {
    @IBOutlet fileprivate(set) weak var tableView: UITableView!
    let viewModel: ProfileViewModel = ProfileViewModel()

    enum Sections: Int {
        case avatar
        case information

        static var count: Int {
            return self.information.rawValue + 1
        }

        var numberOfRows: Int {
            switch self {
            case .avatar:
                return 1
            case .information:
                return InfoRows.count
            }
        }

        var heightForRows: CGFloat {
            switch self {
            case .avatar:
                return 120
            case .information:
                return 50
            }
        }
    }

    enum InfoRows: Int {
        case mail
        case weight
        case height
        case birthday
        case gender
        case caloriesPerDay

        static var count: Int {
            return self.caloriesPerDay.rawValue + 1
        }

        var title: String {
            switch self {
            case .mail:
                return Strings.email
            case .weight:
                return Strings.weight
            case .height:
                return Strings.height
            case .birthday:
                return Strings.birthday
            case .gender:
                return Strings.gender
            case .caloriesPerDay:
                return Strings.caloriesPerDay
            }
        }
    }

    override func setupUI() {
        super.setupUI()
        viewModel.delegate = self
        configureNavigationBar()
        configureTableView()
    }

    private func configureTableView() {
        tableView.register(AvatarProfileCell.self)
        tableView.register(DetailCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    private func configureNavigationBar() {
        title = Strings.profile
    }
}

// MARK: - ProfileViewModelDelegate
extension ProfileViewController: ProfileViewModelDelegate {
    func viewModel(_ viewModel: ProfileViewModel, needsPerformAction action: ProfileViewModel.Action) {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = Sections(rawValue: section) else {
            fatalError(Strings.Errors.enumError)
        }
        return sections.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sections = Sections(rawValue: indexPath.section) else {
            fatalError(Strings.Errors.enumError)
        }
        switch sections {
        case .avatar:
            let cell = tableView.dequeue(AvatarProfileCell.self)
            cell.data = viewModel.dataForAvatarCell()
            return cell
        case .information:
            guard let rows = InfoRows(rawValue: indexPath.row) else {
                fatalError(Strings.Errors.enumError)
            }
            let cell = tableView.dequeue(DetailCell.self)
            cell.data = viewModel.dataForDetailCell(at: rows)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sections = Sections(rawValue: indexPath.section) else {
            fatalError(Strings.Errors.enumError)
        }
        switch sections {
        case .avatar: break
        case .information:
            guard let rows = InfoRows(rawValue: indexPath.row) else {
                fatalError(Strings.Errors.enumError)
            }
            let updateProfileController = UpdateProfileController()
            switch rows {
            case .mail: return
            case .weight:
                updateProfileController.viewModel = UpdateProfileViewModel(row: .weight)
            case .height:
                updateProfileController.viewModel = UpdateProfileViewModel(row: .height)
            case .birthday: return
            case .gender: return
            case .caloriesPerDay: return
            }
            navigationController?.pushViewController(updateProfileController, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sections = Sections(rawValue: indexPath.section) else {
            fatalError(Strings.Errors.enumError)
        }
        return sections.heightForRows
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}
