//
//  HistoryViewController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/23/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import FSCalendar
import SwiftDate

final class HistoryViewController: RootSideMenuViewController {
    @IBOutlet fileprivate weak var calendar: FSCalendar!
    var currentCell: FSCalendarCell?

    override func setupUI() {
        super.setupUI()
        title = Strings.history
        configureCalendar()
    }

    private func configureCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
    }
}

// MARK: - FSCalendarDataSource
extension HistoryViewController: FSCalendarDataSource {

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if date.ffDate().day % 4 == 0 {
            return 1
        }
        return 0
    }
}

// MARK: - FSCalendarDelegate
extension HistoryViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        currentCell = calendar.cell(for: date, at: .current)
    }
}
