//
//  LeftSideViewController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/21/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import PureLayout

class LeftSideViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.contentInset.top = 20
        tableView.separatorInset = .zero
    }
}

// MARK: - UITableViewDataSource
extension LeftSideViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value2, reuseIdentifier: nil)
        cell.textLabel?.text = "ABC"
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LeftSideViewController {

}
