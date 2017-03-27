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

class HistoryViewController: RootSideMenuViewController {
    @IBOutlet fileprivate weak var calendar: FSCalendar!
    var currentDate: DateInRegion?

    override func setupUI() {
        super.setupUI()
        title = Strings.history
        configureCalendar()
        print(DateInRegion().toString(format: .date))
    }

    private func configureCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
    }
}

// MARK: - FSCalendarDataSource
extension HistoryViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        if (DateInRegion() + 1.day).ffDate() == date.ffDate() {
            return "😍"
        }
        return nil
    }
}

// MARK: - FSCalendarDelegate
extension HistoryViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        currentDate = date.ffDate()
    }
}
