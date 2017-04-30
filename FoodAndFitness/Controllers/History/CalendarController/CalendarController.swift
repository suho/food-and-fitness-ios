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
    lazy var viewModel: CalendarViewModel = CalendarViewModel()

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
        guard let selectedCell = viewModel.selectedCell else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        navigationItem.rightBarButtonItem?.isEnabled = selectedCell.numberOfEvents > 0
    }

    @objc private func gotoHistory() {
        guard let selectedCell = viewModel.selectedCell, let selectedDate = viewModel.selectedDate else {
            let error = NSError(message: Strings.Errors.noHistory)
            error.show()
            return
        }
        let numberOfEvents = selectedCell.numberOfEvents
        if numberOfEvents > 0 {
            let historyViewController = HistoryViewController()
            historyViewController.viewModel = HistoryViewModel(date: selectedDate)
            navigationController?.pushViewController(historyViewController, animated: true)
        }
    }
}

// MARK: - FSCalendarDataSource
extension CalendarController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        if !date.isToday && viewModel.didHaveEvents(forDate: date) {
        if viewModel.didHaveEvents(forDate: date) {
            return 1
        } else {
            return 0
        }
    }
}

// MARK: - FSCalendarDelegate
extension CalendarController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.selectedCell = calendar.cell(for: date, at: monthPosition)
        viewModel.selectedDate = date
        rightButtonEnabled()
    }
}
