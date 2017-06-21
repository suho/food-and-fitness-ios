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
        case logout

        static var count: Int {
            return self.logout.rawValue + 1
        }

        var numberOfRows: Int {
            switch self {
            case .avatar:
                return 1
            case .information:
                return InfoRows.count
            case .logout:
                return 1
            }
        }

        var heightForRows: CGFloat {
            switch self {
            case .avatar:
                return 120
            case .information:
                return 50
            case .logout:
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
        case goal
        case active

        static var count: Int {
            return self.active.rawValue + 1
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
            case .goal:
                return Strings.goal
            case .active:
                return Strings.active
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
        case .logout:
            let cell = tableView.dequeue(DetailCell.self)
            cell.data = DetailCell.Data(title: Strings.logout, detail: Strings.empty, detailColor: .black)
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
            switch rows {
            case .mail: return
            case .weight:
                let updateProfileController = UpdateProfileController()
                updateProfileController.viewModel = UpdateProfileViewModel(row: .weight)
                navigationController?.pushViewController(updateProfileController, animated: true)
            case .height:
                let updateProfileController = UpdateProfileController()
                updateProfileController.viewModel = UpdateProfileViewModel(row: .height)
                navigationController?.pushViewController(updateProfileController, animated: true)
            case .birthday: return
            case .gender: return
            case .caloriesPerDay: return
            case .goal:
                let chooseUpdateController = ChooseUpdateController()
                chooseUpdateController.viewModel = ChooseUpdateViewModel(dataType: .goal)
                navigationController?.pushViewController(chooseUpdateController, animated: true)
            case .active:
                let chooseUpdateController = ChooseUpdateController()
                chooseUpdateController.viewModel = ChooseUpdateViewModel(dataType: .active)
                navigationController?.pushViewController(chooseUpdateController, animated: true)
            }
        case .logout:
            api.logout()
            AppDelegate.shared.gotoSignUp()
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
