//
//  ChooseUpdateController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 5/24/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

final class ChooseUpdateController: BaseViewController {
    @IBOutlet fileprivate weak var tableView: UITableView!
    var viewModel: ChooseUpdateViewModel!

    override func setupUI() {
        super.setupUI()
        configureNavigationBar()
        configureTableView()
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    private func configureNavigationBar() {
        title = viewModel.dataType.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Strings.done, style: .done, target: self, action: #selector(update))
    }

    private func getSuggestion() {
        HUD.show()
        viewModel.getSuggestion { [weak self](result) in
            HUD.dismiss()
            guard let this = self else { return }
            switch result {
            case .success(_):
                this.navigationController?.popViewController(animated: true)
            case .failure(let error):
                error.show()
            }
        }
    }

    @objc fileprivate func update() {
        HUD.show()
        viewModel.update { [weak self](result) in
            HUD.dismiss()
            guard let this = self else { return }
            switch result {
            case .success(_):
                this.getSuggestion()
            case .failure(let error):
                error.show()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ChooseUpdateController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.dataType {
        case .active:
            return Actives.veryActive.rawValue
        case .goal:
            return Goals.gainWeight.rawValue
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        switch viewModel.dataType {
        case .active:
            guard let active = Actives(rawValue: indexPath.row + 1) else {
                fatalError(Strings.Errors.enumError)
            }
            cell.textLabel?.text = active.title
            if viewModel.value == active.rawValue {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        case .goal:
            guard let goal = Goals(rawValue: indexPath.row + 1) else {
                fatalError(Strings.Errors.enumError)
            }
            cell.textLabel?.text = goal.title
            if viewModel.value == goal.rawValue {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ChooseUpdateController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.value = indexPath.row + 1
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
}
