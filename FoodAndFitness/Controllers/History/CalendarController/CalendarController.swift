//
//  CalendarController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/30/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import FSCalendar
import SwiftDate

final class CalendarController: RootSideMenuViewController {
    @IBOutlet fileprivate(set) weak var calendar: FSCalendar!
    var currentCell: FSCalendarCell?

    override func setupUI() {
        super.setupUI()
        title = Strings.history
        navigationBar()
        configureCalendar()
    }

    private func navigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(gotoHistory))
        rightButtonEnabled()
    }

    private func configureCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
    }

    fileprivate func rightButtonEnabled() {
        if let numberOfEvents = currentCell?.numberOfEvents, numberOfEvents > 0 {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    @objc private func gotoHistory() {
        if let numberOfEvents = currentCell?.numberOfEvents, numberOfEvents > 0 {
            let historyViewController = HistoryViewController()
            navigationController?.pushViewController(historyViewController, animated: true)
        } else {
            let error = NSError(message: Strings.Errors.noHistory)
            error.show()
        }
    }
}

// MARK: - FSCalendarDataSource
extension CalendarController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if date.ffDate().day % 4 == 0 && date.ffDate() < DateInRegion() {
            return 1
        }
        return 0
    }
}

// MARK: - FSCalendarDelegate
extension CalendarController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        currentCell = calendar.cell(for: date, at: monthPosition)
        rightButtonEnabled()
    }
}
