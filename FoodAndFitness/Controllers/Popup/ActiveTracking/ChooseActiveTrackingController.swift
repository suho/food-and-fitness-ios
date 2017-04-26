//
//  ChooseActiveTrackingController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/21/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit

protocol ChooseActiveTrackingControllerDelegate: class {
    func viewController(_ viewController: ChooseActiveTrackingController, needsPerformAction action: ChooseActiveTrackingController.Action)
}

final class ChooseActiveTrackingController: PopupViewController {
    @IBOutlet fileprivate(set) weak var tableView: UITableView!
    weak var delegate: ChooseActiveTrackingControllerDelegate?
    fileprivate var currentActive: ActiveTracking = .running

    enum Action {
        case dismiss(ActiveTracking)
    }

    override func setupUI() {
        super.setupUI()
        configureTableView()
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func okey(_ sender: Any) {
        UIView.animate(withDuration: 0.1, animations: { 
            self.view.backgroundColor = .clear
        }) { (_) in
            self.dismiss(animated: true) {
                self.delegate?.viewController(self, needsPerformAction: .dismiss(self.currentActive))
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ChooseActiveTrackingController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActiveTracking.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let active = ActiveTracking(rawValue: indexPath.row) else { fatalError(Strings.Errors.enumError) }
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = active.title
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ChooseActiveTrackingController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 3
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let active = ActiveTracking(rawValue: indexPath.row) else { fatalError(Strings.Errors.enumError) }
        currentActive = active
    }
}
